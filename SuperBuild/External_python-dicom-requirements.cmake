set(proj python-dicom-requirements)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
  python-numpy
  python-pip
  python-requests-requirements
  python-setuptools
  )

if(NOT DEFINED Slicer_USE_SYSTEM_${proj})
  set(Slicer_USE_SYSTEM_${proj} ${Slicer_USE_SYSTEM_python})
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(Slicer_USE_SYSTEM_${proj})
  foreach(module_name IN ITEMS
    pydicom
    six
    )
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
  ExternalProject_FindPythonPackage(
    MODULE_NAME PIL #pillow
    REQUIRED
    )
  ExternalProject_FindPythonPackage(
    MODULE_NAME dicomweb_client
    NO_VERSION_PROPERTY
    REQUIRED
    )
endif()

if(NOT Slicer_USE_SYSTEM_${proj})

  ExternalProject_Add_PyPIPackage(
    PROJECT python-pydicom
    PACKAGE pydicom==2.4.4
    PACKAGE_HASH sha256:f9f8e19b78525be57aa6384484298833e4d06ac1d6226c79459131ddb0bd7c42
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-six
    PACKAGE six==1.16.0
    PACKAGE_HASH sha256:8abb2f1d86890a2dfb989f9a77cfcfd3e47c2a354b01111771326f8aa26e0254
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-pillow
    PACKAGE pillow==10.3.0
    PACKAGE_HASH sha256:b09b86b27a064c9624d0a6c54da01c1beaf5b6cadfa609cf63789b1d08a797b9
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-retrying
    PACKAGE retrying==1.3.4
    PACKAGE_HASH sha256:8cc4d43cb8e1125e0ff3344e9de678fefd85db3b750b81b2240dc0183af37b35
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-dicomweb-client
    PACKAGE dicomweb-client==0.59.1
    PACKAGE_HASH sha256:ad4af95e1bdeb3691841cf8b28894fc6d9ba7ac5b7892bff70a506eedbd20d79
    CAN_BE_OVERRIDDEN
  )

  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  file(WRITE ${requirements_file}
"# [pydicom]\n
${python-pydicom_FETCH_METHOD}\n
# [/pydicom]\n
# [six]\n
${python-six_FETCH_METHOD}\n
# [/six]\n
# [pillow]\n
${python-pillow_FETCH_METHOD}\n
# [/pillow]\n
# [retrying]\n
${python-retrying_FETCH_METHOD}\n
# [/retrying]\n
# [dicomweb-client]\n
${python-dicomweb-client_FETCH_METHOD}\n
# [/dicomweb-client]\n")

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
