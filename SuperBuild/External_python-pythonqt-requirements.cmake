set(proj python-pythonqt-requirements)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
  python-ensurepip
  python-pip
  python-setuptools
  python-wheel
  )

if(NOT DEFINED Slicer_USE_SYSTEM_${proj})
  set(Slicer_USE_SYSTEM_${proj} ${Slicer_USE_SYSTEM_python})
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(Slicer_USE_SYSTEM_${proj})
  foreach(module_name IN ITEMS
    packaging
    pyparsing
    )
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
endif()

if(NOT Slicer_USE_SYSTEM_${proj})

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_packaging
    PACKAGE packaging==24.0
    PACKAGE_HASH sha256:2ddfb553fdf02fb784c234c7ba6ccc288296ceabec964ad2eae3777778130bc5
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_pyparsing
    PACKAGE pyparsing==3.1.2
    PACKAGE_HASH sha256:f9db75911801ed778fe61bb643079ff86601aca99fcae6345aa67292038fb742
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_six
    PACKAGE six==1.16.0
    PACKAGE_HASH sha256:8abb2f1d86890a2dfb989f9a77cfcfd3e47c2a354b01111771326f8aa26e0254
    CAN_BE_OVERRIDDEN
  )

  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  set(requirements_file_content
"# [packaging]\n
${${proj}_pydicom_FETCH_URL}\n
# [/packaging]\n
# [pyparsing]\n
${${proj}_pydicom_FETCH_URL}\n
# [/pyparsing]\n
# [six]\n
${${proj}_pydicom_FETCH_URL}\n
# [/six]\n
")
  file(WRITE ${requirements_file} ${requirements_file_content})

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${PYTHON_EXECUTABLE} -m pip install --require-hashes -r ${requirements_file}
    LOG_INSTALL 1
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()
