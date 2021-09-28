set(KIT ${PROJECT_NAME})

#-----------------------------------------------------------------------------
set(INPUT ${MRMLCore_SOURCE_DIR}/Testing)

#-----------------------------------------------------------------------------
set(KIT_TEST_SOURCES
  qMRMLMarkupsAdditionalOptionsWidgetsFactoryTest.cxx
  qMRMLSimpleMarkupsWidgetTest1.cxx
  )

create_test_sourcelist(Tests ${KIT}CppTests.cxx
  ${KIT_TEST_SOURCES}
  )

set(Tests_MOC_SRCS
  qMRMLMarkupsMalformedWidget.h
  qMRMLMarkupsAdditionalMalformedOptionsWidget.h
  )

set(Test_UI_SRCS
  Resources/UI/qMRMLMarkupsAdditionalMalformedOptionsWidget.ui
  )

set(Tests_UtilityFiles
  qMRMLMarkupsMalformedWidget.h
  qMRMLMarkupsMalformedWidget.cxx
  qMRMLMarkupsAdditionalMalformedOptionsWidget.h
  qMRMLMarkupsAdditionalMalformedOptionsWidget.cxx
  )

set(KIT_TEST_GENERATE_MOC_SRCS
  qMRMLMarkupsAdditionalOptionsWidgetsFactoryTest.cxx
  )

set(_moc_options OPTIONS -DMRML_WIDGETS_HAVE_QT5)
QT5_WRAP_CPP(Tests_MOC_CXX ${Tests_MOC_SRCS} ${_moc_options})
QT5_WRAP_UI(Test_UI_CXX ${Test_UI_SRCS})

include_directories( ${CMAKE_CURRENT_BINARY_DIR})
include_directories( ${CMAKE_CURRENT_SOURCE_DIR})

ctk_add_executable_utf8(${KIT}CxxTests ${Test_UI_CXX} ${Tests} ${Tests_MOC_CXX} ${Tests_UtilityFiles})
target_link_libraries(${KIT}CxxTests ${KIT})

set_target_properties(${KIT}CxxTests PROPERTIES FOLDER "Module-${KIT}")

#-----------------------------------------------------------------------------
simple_test( qMRMLMarkupsAdditionalOptionsWidgetsFactoryTest )
simple_test( qSlicerSimpleMarkupsWidgetTest1 )
