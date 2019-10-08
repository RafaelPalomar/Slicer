project(vtkSlicer${MODULE_NAME}ModuleMRML)

set(KIT ${PROJECT_NAME})

set(${KIT}_EXPORT_DIRECTIVE "VTK_SLICER_${MODULE_NAME_UPPER}_MODULE_MRML_EXPORT")

find_package(jsoncpp REQUIRED)

get_target_property(jsoncpp_INCLUDE_DIR jsoncpp_lib INTERFACE_INCLUDE_DIRECTORIES)

set(${KIT}_INCLUDE_DIRECTORIES
  ${jsoncpp_INCLUDE_DIR}
  ${Slicer_INSTALL_QTLOADABLEMODULES_INCLUDE_DIR}/vtkSlicerAnnotationsModuleMRML
  )

set(${KIT}_SRCS
  vtkMRMLCPURayCast${MODULE_NAME}DisplayNode.cxx
  vtkMRMLCPURayCast${MODULE_NAME}DisplayNode.h
  vtkMRMLGPURayCast${MODULE_NAME}DisplayNode.cxx
  vtkMRMLGPURayCast${MODULE_NAME}DisplayNode.h
  vtkMRMLMulti${MODULE_NAME}DisplayNode.cxx
  vtkMRMLMulti${MODULE_NAME}DisplayNode.h
  vtkMRMLShaderPropertyNode.cxx
  vtkMRMLShaderPropertyNode.h
  vtkMRMLShaderPropertyStorageNode.cxx
  vtkMRMLShaderPropertyStorageNode.h
  vtkMRMLVolumePropertyNode.cxx
  vtkMRMLVolumePropertyNode.h
  vtkMRMLVolumePropertyStorageNode.cxx
  vtkMRMLVolumePropertyStorageNode.h
  vtkMRML${MODULE_NAME}DisplayNode.cxx
  vtkMRML${MODULE_NAME}DisplayNode.h
  )

set(${KIT}_TARGET_LIBRARIES
  ${ITK_LIBRARIES}
  ${JsonCpp_LIBRARY}
  ${MRML_LIBRARIES}
  vtkSlicerAnnotationsModuleMRML
  jsoncpp
  )

link_directories(
  ${Slicer_HOME}/${Slicer_INSTALL_LIB_DIR}
  ${Slicer_INSTALL_QTLOADABLEMODULES_LIB_DIR}
)

if(NOT Slicer_USE_PYTHONQT)
  set(DISABLE_PYTHON DISABLE_WRAP_PYTHON)
endif()

#-----------------------------------------------------------------------------
SlicerMacroBuildModuleMRML(
  ${DISABLE_PYTHON}
  NAME ${KIT}
  EXPORT_DIRECTIVE ${${KIT}_EXPORT_DIRECTIVE}
  INCLUDE_DIRECTORIES ${${KIT}_INCLUDE_DIRECTORIES}
  SRCS ${${KIT}_SRCS}
  TARGET_LIBRARIES ${${KIT}_TARGET_LIBRARIES}
  )
