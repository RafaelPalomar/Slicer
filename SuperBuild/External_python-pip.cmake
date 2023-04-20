set(proj python-pip)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
  python-ensurepip
  python-setuptools
  )

if(NOT DEFINED Slicer_USE_SYSTEM_${proj})
  set(Slicer_USE_SYSTEM_${proj} ${Slicer_USE_SYSTEM_python})
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(Slicer_USE_SYSTEM_${proj})
  foreach(module_name IN ITEMS pip)
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
endif()

if(NOT Slicer_USE_SYSTEM_${proj})
  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  file(WRITE ${requirements_file} [===[
  # [pip]
  pip==23.1.2 --hash=sha256:3ef6ac33239e4027d9a5598a381b9d30880a1477e50039db2eac6e8a8f6d1b18
  # [/pip]
  ]===])

  # # This block considers the possibility that the dependencies are given as a single file (one dependency)
  # # or as a directory of dependencies, in which case all the *.whl files in the directory will be installed
  if(DEFINED Slicer_${proj}_WHEEL_PATH)
    if(IS_DIRECTORY "${Slicer_${proj}_WHEEL_PATH}")
      set(Slicer_${proj}_INSTALL_COMMAND ${PYTHON_EXECUTABLE} -m pip install --no-deps)
      file(GLOB WHEEL_FILES "${Slicer_${proj}_WHEEL_PATH}/*.whl")
      foreach(WHEEL_FILE ${WHEEL_FILES})
        set(Slicer_${proj}_INSTALL_COMMAND ${Slicer_${proj}_INSTALL_COMMAND} ${WHEEL_FILE})
      endforeach()
    else()
      set(Slicer_${proj}_INSTALL_COMMAND ${PYTHON_EXECUTABLE} -m pip install --no-deps ${Slicer_${proj}_WHEEL_PATH})
    endif()
  else()
    set(Slicer_${proj}_INSTALL_COMMAND ${PYTHON_EXECUTABLE} -m pip install --require-hashes -r ${requirements_file})
  endif()

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${Slicer_${proj}_INSTALL_COMMAND}
    LOG_INSTALL 1
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

  ExternalProject_GenerateProjectDescription_Step(${proj}
    VERSION ${_version}
    )

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()
