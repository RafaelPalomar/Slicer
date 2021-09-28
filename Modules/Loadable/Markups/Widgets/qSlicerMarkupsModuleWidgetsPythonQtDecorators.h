/*=auto=========================================================================

 Portions (c) Copyright 2005 Brigham and Women's Hospital (BWH)
 All Rights Reserved.

 See COPYRIGHT.txt
 or http://www.slicer.org/copyright/copyright.txt for details.

 Program:   3D Slicer

=========================================================================auto=*/

#ifndef __qSlicerMarkupsModuleWidgetsPythonQtDecorators_h
#define __qSlicerMarkupsModuleWidgetsPythonQtDecorators_h

// PythonQt includes
#include <PythonQt.h>

// Slicer includes
#include "qMRMLMarkupsAdditionalOptionsWidgetsFactory.h"

#include "qSlicerMarkupsModuleWidgetsExport.h"

// NOTE:
//
// For decorators it is assumed that the methods will never be called
// with the self argument as nullptr.  The self argument is the first argument
// for non-static methods.
//

class qSlicerMarkupsModuleWidgetsPythonQtDecorators : public QObject
{
  Q_OBJECT
public:

  qSlicerMarkupsModuleWidgetsPythonQtDecorators()
    {
    //PythonQt::self()->registerClass(&qMRMLMarkupsAdditionalOptionsWidgetsFactory::staticMetaObject);
    // Note: Use registerCPPClassForPythonQt to register pure Cpp classes
    }

public slots:

  //----------------------------------------------------------------------------
  // qMRMLMarkupsAdditionalOptionsWidgetsFactory

  //----------------------------------------------------------------------------
  // static methods

  //----------------------------------------------------------------------------
  qMRMLMarkupsAdditionalOptionsWidgetsFactory* static_qMRMLMarkupsAdditionalOptionsWidgetsFactory_instance()
    {
    return qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
    }

  //----------------------------------------------------------------------------
  // instance methods

  //----------------------------------------------------------------------------
  bool registerAdditionalOptionsWidget(qMRMLMarkupsAdditionalOptionsWidgetsFactory* factory,
                                       PythonQtPassOwnershipToCPP<qMRMLMarkupsAdditionalOptionsWidget*> plugin)
    {
    return factory->registerAdditionalOptionsWidget(plugin);
    }
};

//-----------------------------------------------------------------------------
void initqSlicerMarkupsModuleWidgetsPythonQtDecorators()
{
  PythonQt::self()->addDecorators(new qSlicerMarkupsModuleWidgetsPythonQtDecorators);
}

#endif
