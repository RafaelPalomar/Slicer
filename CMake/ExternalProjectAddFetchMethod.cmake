macro(ExternalProject_Add_FetchMethod)
  set(options CAN_BE_OVERRIDEN)
  set(oneValueArgs
    PROJECT        #Mandatory
    SOURCE_DIR     #Optional
    GIT_REPOSITORY #Optional
    GIT_TAG        #Optional
    ARCHIVE        #Optional
    ARCHIVE_MD5    #Optional
  )

  cmake_parse_arguments(_fm
    "${options}"
    "${oneValueArgs}"
    ${ARGN}
  )

  #-----------------
  # Sanity checks
  #-----------------

  # Check for project name
  if(NOT _fm_PROJECT)
    message(FATAL_ERROR "Parameter PROJECT not specified!")
  endif()

  # Check at least there is a fetch method
  if(NOT _fm_SOURCE_DIR and
      NOT _fm_GIT_REPOSITORY and
      NOT _fm_ARCHIVE)
    message(FATAL_ERROR "At least one of the following parameters need to be specified: SOURCE_DIR, GIT_REPOSITORY or ARCHIVE!")
  endif()

  # Check mutually exclusive fetch metods
  if(_fm_GIT_REPOSITORY and _fm_ARCHIVE)
    message(FATAL_ERROR "GIT_REPOSITORY and ARCHIVE are mutually exclusive! Please set only one of these parameters")
  endif()

  #Create and initialize ${PROJECT}_FETCH_METHOD
  set(${PROJECT}_FETCH_METHOD "" PARENT_SCOPE)


  #-----------------
  # CAN_BE_OVERRIDEN
  #-----------------
  # The specified method is just a default that can be overriden
  # by setting the corresponding ${PROJECT}_<GIT_REPOSITORY|ARCHIVE|SOURCE_DIR>[_<GIT_TAG|ARCHIVE_MD5>](e.g., externally).
  if(_fm_CAN_BE_OVERRIDEN)

    # GIT is default
    if(_fm_GIT_REPOSITORY)

      #Check whether there exists an archive to override
      if(${PROJECT}_ARCHIVE)

        if(${PROJECT}_ARCHIVE_MD5)
          message(STATUS "Setting fetch method to archive: ${${PROJECT}_ARCHIVE} with MD5 ${${PROJECT}_ARCHIVE_MD5}")

          list(APPEND ${PROJECT}_FETCH_METHOD
            URL "${${PROJECT}_ARCHIVE}"
            URL_MD5 "${${PROJECT}_ARCHIVE_MD5}"
          )
        else()
          message(FATAL_ERROR "${PROJECT}_ARCHIVE overriding option detected, but no ${PROJECT}_ARCHIVE_MD5 specified!")
        endif()
      else()
        message(STATUS "Setting fetch method to default (git): ${_fm_GIT_REPOSITORY} with TAG ${_fm_GIT_TAG}")

        list(APPEND ${PROJECT}_FETCH_METHOD
          GIT_REPOSITORY "${_dm_GIT_REPOSITORY}"
          GIT_TAG "${_fm_GIT_TAG}"
        )
      endif()
    endif()
    # GIT is default
    if(_fm_ARCHIVE)

      #Check if there exist an archive to override
      if(${PROJECT}_GIT_REPOSITORY)

        if(${PROJECT}_GIT_TAG)
          message(STATUS "Setting fetch method to git: ${${PROJECT}_GIT_REPOSITORY} with TAG ${${PROJECT}_GIT_TAG}")

          list(APPEND ${PROJECT}_FETCH_METHOD
            GIT_REPOSITORY "${${PROJECT}_GIT_REPOSITORY}"
            GIT_TAG "${${PROJECT}_GIT_TAG}"
          )
        else()
          message(FATAL_ERROR "${PROJECT}_GIT_REPOSITORY overriding option detected, but no ${PROJECT}_GIT_TAG specified!")
        endif()
      else()
        message(STATUS "Setting fetch method to default (archive): ${_fm_ARCHIVE} with MD5 ${_fm_ARCHIVE_MD5}")

        list(APPEND ${PROJECT}_FETCH_METHOD
          ARCHIVE "${_dm_ARCHIVE}"
          ARCHIVE_MD5 "${_fm_ARCHIVE_MD5}"
        )
      endif()

      #Check whether there exists a source to override
      if(${PROJECT}_SOURCE_DIR)
        message(STATUS "Setting source ${PROJECT}_SOURCE_DIR to ${${PROJECT}_SOURCE_DIR}")

        list(APPEND ${PROJECT}_FETCH_METHOD
          SOURCE_DIR "${${PROJECT}_SOURCE_DIR}"
        )
      elseif(_fm_SOURCE_DIR)
        message(STATUS "Setting source ${PROJECT}_SOURCE_DIR to ${_fm_SOURCE_DIR}")

        list(APPEND ${PROJECT}_FETCH_METHOD
          SOURCE_DIR "${_fm_SOURCE_DIR}"
        )
      endif()
    endif()

  else() #NOT CAN_BE_OVERRIDEN


    # GIT is default
    if(_fm_ARCHIVE)

      message(STATUS "Setting fetch method to arhive: ${_fm_ARCHIVE} with MD5 ${_fm_ARCHIVE_MD5}")

      list(APPEND ${PROJECT}_FETCH_METHOD
        ARCHIVE "${_dm_ARCHIVE}"
        ARCHIVE_MD5 "${_fm_ARCHIVE_MD5}"
      )
    endif()


    # GIT is default
    if(_fm_GIT_REPOSITORY)

      message(STATUS "Setting fetch method to arhive: ${_fm_GIT_REPOSITORY} with MD5 ${_fm_GIT_TAG}")

      list(APPEND ${PROJECT}_FETCH_METHOD
        GIT_REPOSITORY "${_dm_GIT_REPOSITORY}"
        GIT_TAG "${_fm_GIT_TAG}"
      )
    endif()
  endif()
endmacro()
