set(proj python-extension-manager-ssl-requirements)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
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
  foreach(module_name IN ITEMS jwt wrapt deprecated pycparser cffi nacl dateutil)
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
  ExternalProject_FindPythonPackage(
    MODULE_NAME github
    NO_VERSION_PROPERTY
    REQUIRED
    )
endif()

if(NOT Slicer_USE_SYSTEM_${proj})

  ExternalProject_Add_PyPIPackage(
    PROJECT python-cryptography
    PACKAGE cryptography==42.0.7
    PACKAGE_HASH sha256:efd0bf5205240182e0f13bcaea41be4fdf5c22c5129fc7ced4a0282ac86998c9
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-PyJWT
    PACKAGE PyJWT[crypto]==2.8.0
    PACKAGE_HASH sha256:59127c392cc44c2da5bb3192169a91f429924e17aff6534d70fdc02ab3e04320
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-wrapt
    PACKAGE wrapt==1.16.0
    PACKAGE_HASH sha256:f8212564d49c50eb4565e502814f694e240c55551a5f1bc841d4fcaabb0a9b8a
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-Deprecated
    PACKAGE Deprecated==1.2.14
    PACKAGE_HASH sha256:6fac8b097794a90302bdbb17b9b815e732d3c4720583ff1b198499d78470466c
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-pycparser
    PACKAGE pycparser==2.22
    PACKAGE_HASH sha256:c3702b6d3dd8c7abc1afa565d7e63d53a1d0bd86cdc24edd75470f4de499cfcc
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-cffi
    PACKAGE cffi==1.16.0
    PACKAGE_HASH sha256:8f8e709127c6c77446a8c0a8c8bf3c8ee706a06cd44b1e827c3e6a2ee6b8c098
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-PyNaCl
    PACKAGE PyNaCl==1.5.0
    PACKAGE_HASH sha256:0c84947a22519e013607c9be43706dd42513f9e6ae5d39d3613ca1e142fba44d
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-python-dateutil
    PACKAGE python-dateutil==2.9.0.post0
    PACKAGE_HASH sha256:a8b2bc7bffae282281c8140a97d3aa9c14da0b136dfe83f850eea9a5f7470427
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-six
    PACKAGE six==1.16.0
    PACKAGE_HASH sha256:8abb2f1d86890a2dfb989f9a77cfcfd3e47c2a354b01111771326f8aa26e0254
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-typing_extensions
    PACKAGE typing_extensions==4.12.1
    PACKAGE_HASH sha256:6024b58b69089e5a89c347397254e35f1bf02a907728ec7fee9bf0fe837d203a
    CAN_BE_OVERRIDDEN
  )

  ExternalProject_Add_PyPIPackage(
    PROJECT python-PyGithub
    PACKAGE PyGithub==2.3.0
    PACKAGE_HASH sha256:65b499728be3ce7b0cd2cd760da3b32f0f4d7bc55e5e0677617f90f6564e793e
    CAN_BE_OVERRIDDEN
  )

  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  set(requirements_file_content
"# [cryptography]\n
${python-cryptography_FETCH_METHOD}\n
# [/cryptography]\n
# [PyJWT]\n
${python-PyJWT_FETCH_METHOD}\n
# [/PyJWT]\n
# [wrapt]\n
${python-wrapt_FETCH_METHOD}\n
# [/wrapt]\n
# [Deprecated]\n
${python-Deprecated_FETCH_METHOD}\n
# [/Deprecated]\n
# [pycparser]\n
${python-pycparser_FETCH_METHOD}\n
# [/pycparser]\n
# [cffi]\n
${python-cffi_FETCH_METHOD}\n
# [/cffi]\n
# [PyNaCl]\n
${python-PyNaCl_FETCH_METHOD}\n
# [/PyNaCl]\n
# [python-dateutil]\n
${python-python-dateutil_FETCH_METHOD}\n
# [/python-dateutil]\n
# [six]\n
${python-six_FETCH_METHOD}\n
# [/six]\n
# [typing_extensions]\n
${python-typing_extensions_FETCH_METHOD}\n
# [/typing_extensions]\n
# [PyGithub]\n
${python-PyGithub_FETCH_METHOD}\n
# [/PyGithub]\n
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
