set(proj python-requests-requirements)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
  python-pip
  python-setuptools
  )

if(NOT DEFINED Slicer_USE_SYSTEM_${proj})
  set(Slicer_USE_SYSTEM_${proj} ${Slicer_USE_SYSTEM_python})
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(Slicer_USE_SYSTEM_${proj})
  foreach(module_name IN ITEMS certifi idna charset-normalizer urllib3 requests)
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
endif()

if(NOT Slicer_USE_SYSTEM_${proj})

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_certifi
    PACKAGE certifi==2024.2.2
    PACKAGE_HASH sha256:dc383c07b76109f368f6106eee2b593b04a011ea4d55f652c6ca24a754d1cdd1
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_idna
    PACKAGE idna==3.7
    PACKAGE_HASH sha256:82fee1fc78add43492d3a1898bfa6d8a904cc97d8427f683ed8e798d07761aa0
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_charset-normalizer
    PACKAGE charset-normalizer==3.3.2
    PACKAGE_HASH sha256:b261ccdec7821281dade748d088bb6e9b69e6d15b30652b74cbbac25e280b796
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_urllib3
    PACKAGE urllib3==2.2.1
    PACKAGE_HASH sha256:450b20ec296a467077128bff42b73080516e71b56ff59a60a02bef2232c4fa9d
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT ${proj}_requests
    PACKAGE requests==2.32.3
    PACKAGE_HASH sha256:70761cfe03c773ceb22aa2f671b4757976145175cdfca038c02654d061d6dcc6
    CAN_BE_OVERRIDDEN
  )

  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  set(requirements_file_content
"# [certifi]\n
${${proj}_certifi_FETCH_METHOD}\n
# [/certifi]\n
# [idna]\n
${${proj}_idna_FETCH_METHOD}\n
# [/idna]\n
# [charset-normalizer]\n
${${proj}_idna_FETCH_METHOD}\n
#[/charset-normalizer]\n
# [urllib3]\n
${${proj}_urllib3_FETCH_METHOD}\n
# [/urllib3]\n
# [requests]\n
${${proj}_urllib3_FETCH_METHOD}\n
# [/requests]")
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
