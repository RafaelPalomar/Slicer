
macro(ExternalProject_Add_PyPIPackage)
  set(options CAN_BE_OVERRIDDEN)
  set(oneValueArgs
    PROJECT        #Mandatory
    PACKAGE        #Mandatory
    PACKAGE_HASH   #Mandatory
  )
  set(multiValueArgs)

  cmake_parse_arguments(_pyfm "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #-----------------
  # Sanity checks
  #-----------------

  # Check for project name
  if((NOT _pyfm_PROJECT) OR (NOT _pyfm_PACKAGE) OR (NOT _pyfm_PACKAGE_HASH))
    message(FATAL_ERROR "PROJECT, PACKAGE and PACKAGE_HASH are mandatory parameters. Missing one/some of them!")
  endif()

  set(${_pyfm_PROJECT}_FETCH_METHOD)

  message(STATUS "Setting fetch method to archive: ${_pyfm_PACKAGE} with HASH ${_pyfm_PACKAGE_HASH}")
  set(${_pyfm_PROJECT}_FETCH_METHOD "${_pyfm_PACKAGE} --hash=${_pyfm_PACKAGE_HASH}")

  if(_pyfm_CAN_BE_OVERRIDDEN)
    # Check for external ARCHIVE
    if(${_pyfm_PROJECT}_ARCHIVE)
      if(${_pyfm_PROJECT}_ARCHIVE_HASH)
        message(STATUS "Setting fetch method ${_pyfm_PROJECT}_FETCH_METHOD to archive: ${${_pyfm_PROJECT}_ARCHIVE} with HASH ${${_pyfm_PROJECT}_ARCHIVE_HASH}")
        set(${_pyfm_PROJECT}_FETCH_METHOD "${${_pyfm_PROJECT}_ARCHIVE} --hash=${${_pyfm_PROJECT}_ARCHIVE_HASH}")
      else()
        message(FATAL_ERROR "${_pyfm_PROJECT}_ARCHIVE overriding option detected, but no ${_pyfm_PROJECT}_ARCHIVE_HASH specified!")
      endif()
    endif()
  endif()
endmacro()


#TODO: It probably makes sense to split this macro in at least 2 (PYTHON,CMAKE)
macro(ExternalProject_Add_FetchMethod)
  set(options
    CAN_BE_OVERRIDDEN
    CMAKE_DEFINITION
    #This is for the case of Slicer_Remote_Add and maybe should have its own macro
    SKIP_SOURCE_DEFINITION
  )
  set(oneValueArgs
    PROJECT        #Mandatory
    DOWNLOAD_DIR   #Optional
    SOURCE_DIR     #Optional
    GIT_REPOSITORY #Optional
    GIT_TAG        #Optional
    ARCHIVE        #Optional
    ARCHIVE_HASH   #Optional
  )
  set(multiValueArgs)

  cmake_parse_arguments(_fm "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  #-----------------
  # Sanity checks
  #-----------------

  # Check for project name
  if(NOT _fm_PROJECT)
    message(FATAL_ERROR "Parameter PROJECT not specified!")
  endif()

  #Check mutually exclusive output modes
  if(_fm_CMAKE_DEFINITION AND _fm_PYTHON_DEFINITION)
    message(FATAL_ERROR "CMAKE_DEFINITION and PYTHON_DEFINITION are mutually exclusive options. Select only one.")
  endif()

    # Check at least there is a fetch method
    # NOTE: this should go in favor of leaving a purely external definition (e.g., useful for CTK, which is a superbuild in itself)
    # if((NOT _fm_SOURCE_DIR) AND (NOT _fm_GIT_REPOSITORY) AND (NOT _fm_ARCHIVE))
    #   message(FATAL_ERROR "At least one of the following parameters need to be specified: SOURCE_DIR, GIT_REPOSITORY or ARCHIVE!")
    # endif()

    # Check mutually exclusive fetch metods
    if((_fm_GIT_REPOSITORY AND _fm_ARCHIVE) OR
        (_fm_GIT_REPOSITORY AND _fm_SOURCE_DIR) OR
        (_fm_ARCHIVE AND _fm_SOURCE_DIR))
      message(FATAL_ERROR "GIT_REPOSITORY, ARCHIVE and SOURCE_DIR are mutually exclusive! Please set only one of these parameters")
    endif()

    # Check mutually exclusive fetch metods defined externally
    if((${_fm_PROJECT}_GIT_REPOSITORY AND ${_fm_PROJECT}_ARCHIVE) OR
        (${_fm_PROJECT}_GIT_REPOSITORY AND ${_fm_PROJECT}_SOURCE_DIR) OR
        (${_fm_PROJECT}_ARCHIVE AND ${_fm_PROJECT}_SOURCE_DIR))
      message(FATAL_ERROR "GIT_REPOSITORY, ARCHIVE and SOURCE_DIR external definitions for ${_fm_PROJECT} are mutually exclusive! Please set only one of them")
    endif()

    #Create and initialize ${_fm_PROJECT}_FETCH_METHOD
    set(${_fm_PROJECT}_FETCH_METHOD)
    set(_fm_field_SOURCE_DIR SOURCE_DIR)
    set(_fm_field_URL URL)
    set(_fm_field_URL_HASH URL_HASH)
    set(_fm_field_GIT_REPOSITORY GIT_REPOSITORY)
    set(_fm_field_GIT_TAG GIT_TAG)
    if(_fm_CMAKE_DEFINITION)
      set(_fm_field_SOURCE_DIR -D${_fm_PROJECT}_SOURCE_DIR:PATH=)
      set(_fm_field_URL -D${_fm_PROJECT}_URL:STRING=)
      set(_fm_field_URL_HASH -D${_fm_PROJECT}_URL_HASH:STRING=)
      set(_fm_field_GIT_REPOSITORY -D${_fm_PROJECT}_GIT_REPOSITORY:STRING=)
      set(_fm_field_GIT_TAG -D${_fm_PROJECT}_GIT_TAG:STRING=)
    endif()

    #-----------------------------
    #Set the default values

    # Check for SOURCE_DIR
    if(_fm_SOURCE_DIR)
      message(STATUS "Setting fetch method to SOURCE_DIR: ${_fm_SOURCE_DIR}")
      list(APPEND _fm_FETCH_METHOD
        ${_fm_field_SOURCE_DIR} ${_fm_SOURCE_DIR}
      )
      # Check for ARCHIVE
    elseif(_fm_ARCHIVE)
      if(_fm_ARCHIVE_HASH)
        message(STATUS "Setting fetch method to archive: ${_fm_ARCHIVE} with HASH ${_fm_ARCHIVE_HASH}")
        list(APPEND _fm_FETCH_METHOD
          ${_fm_field_URL} "${_fm_ARCHIVE}"
          ${_fm_field_URL_HASH} "${_fm_ARCHIVE_HASH}"
        )
      else()
        message(FATAL_ERROR "_fm_ARCHIVE overriding option detected, but no _fm_ARCHIVE_HASH specified!")
      endif()
      # Check for GIT_REPOSITORY
    elseif(_fm_GIT_REPOSITORY)
      if(_fm_GIT_TAG)
        message(STATUS "Setting fetch method to git: ${_fm_GIT_REPOSITORY} with TAG ${_fm_GIT_TAG}")
        list(APPEND _fm_FETCH_METHOD
          ${_fm_field_GIT_REPOSITORY} "${_fm_GIT_REPOSITORY}"
          ${_fm_field_GIT_TAG} "${_fm_GIT_TAG}"
        )
      else()
        message(FATAL_ERROR "_fm_GIT_REPOSITORY overriding option detected, but no _fm_GIT_TAG specified!")
      endif()
    endif()

    if(_fm_DOWNLOAD_DIR AND (NOT _fm_SOURCE_DIR))
      message(STATUS "Setting download directory for ${_fm_PROJECT} to ${${_fm_PROJECT}_DOWNLOAD_DIR}")
      list(APPEND _FM_FETCH_METHOD
        ${_fm_field_SOURCE_DIR} "${_fm_DOWNLOAD_DIR}"
      )
    endif()

    #--------------------------------------
    # Check and override values, if needed

    if(_fm_CAN_BE_OVERRIDDEN)

      # Check if there is a potential override and reset the _FETCH_METHODS variable
      if(${_fm_PROJECT}_SOURCE_DIR OR ${_fm_PROJECT}_ARCHIVE OR ${_fm_PROJECT}_GIT)
        set(${_fm_PROJECT}_FETCH_METHOD)
      endif()

      # Check for external SOURCE_DIR
      if(${_fm_PROJECT}_SOURCE_DIR)
        message(STATUS "Setting fetch method to SOURCE_DIR: ${${_fm_PROJECT}_SOURCE_DIR}")

        list(APPEND ${_fm_PROJECT}_FETCH_METHOD
          ${_fm_field_SOURCE_DIR} ${${_fm_PROJECT}_SOURCE_DIR}
        )
        # Check for external ARCHIVE
      elseif(${_fm_PROJECT}_ARCHIVE)
        if(${_fm_PROJECT}_ARCHIVE_HASH)
          message(STATUS "Setting fetch method to archive: ${${_fm_PROJECT}_ARCHIVE} with HASH ${${_fm_PROJECT}_ARCHIVE_HASH}")

          list(APPEND ${_fm_PROJECT}_FETCH_METHOD
            ${_fm_field_URL} "${${_fm_PROJECT}_ARCHIVE}"
            ${_fm_field_URL_HASH} "${${_fm_PROJECT}_ARCHIVE_HASH}"
          )
        else()
          message(FATAL_ERROR "${_fm_PROJECT}_ARCHIVE overriding option detected, but no ${_fm_PROJECT}_ARCHIVE_HASH specified!")
        endif()
        # Check for external _GIT_REPOSITORY
      elseif(${_fm_PROJECT}_GIT_REPOSITORY)
        if(${_fm_PROJECT}_GIT_TAG)
          message(STATUS "Setting fetch method to git: ${${_fm_PROJECT}_GIT_REPOSITORY} with TAG ${${_fm_PROJECT}_GIT_TAG}")

          list(APPEND ${_fm_PROJECT}_FETCH_METHOD
            ${_fm_field_GIT_REPOSITORY} "${${_fm_PROJECT}_GIT_REPOSITORY}"
            ${_fm_field_GIT_TAG} "${${_fm_PROJECT}_GIT_TAG}"
          )
        else()
          message(FATAL_ERROR "${_fm_PROJECT}_GIT_REPOSITORY overriding option detected, but no ${_fm_PROJECT}_GIT_TAG specified!")
        endif()
      endif()
      if(NOT SKIP_SOURCE_DEFINITION)
        if(${_fm_PROJECT}_DOWNLOAD_DIR AND (NOT ${_fm_PROJECT}_SOURCE_DIR))
          message(STATUS "Setting download directory for ${_fm_PROJECT}: ${${_fm_PROJECT}_DOWNLOAD_PROJECT}")
          list(APPEND ${_fm_PROJECT}_FETCH_METHOD
            ${_fm_field_SOURCE_DIR} "${{_dm_PROJECT}_DOWNLOAD_DIR}"
          )
        endif()
      endif()
    endif()
  endmacro()
