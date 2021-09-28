/*==============================================================================

  Copyright (c) The Intervention Centre
  Oslo University Hospital, Oslo, Norway. All Rights Reserved.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Rafael Palomar (The Intervention Centre,
  Oslo University Hospital) and was supported by The Research Council of Norway
  through the ALive project (grant nr. 311393).

==============================================================================*/

#ifndef __qslicermarkupsadditionalwidget_h_
#define __qslicermarkupsadditionalwidget_h_

// Qt Slicer includes
#include "qSlicerWidget.h"

#include "qMRMLMarkupsAdditionalOptionsWidget_p.h"

// Markups Widgets includes
#include "qSlicerMarkupsModuleWidgetsExport.h"

//-------------------------------------------------------------------------------
class vtkMRMLMarkupsNode;
class vtkMRMLNode;

//-------------------------------------------------------------------------------
/// \ingroup Slicer_QtModules_Markups
/// \name qMRMLMarkupsAdditionalOptionsWidget
/// \brief qMRMLMarkupsAdditionalOptionsWidget is a base class for the
/// additional options widgets associated to some types of markups.
class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT qMRMLMarkupsAdditionalOptionsWidget
  : public qSlicerWidget
{
  Q_OBJECT

public:
  typedef qSlicerWidget Superclass;
  qMRMLMarkupsAdditionalOptionsWidget(QWidget* parent=nullptr);
  ~qMRMLMarkupsAdditionalOptionsWidget()=default;

  /// Updates the widget based on information from MRML.
  virtual void updateWidgetFromMRML() = 0;

  /// Gets the name of the additional options widget type
  virtual const QString getAdditionalOptionsWidgetTypeName() = 0;

  // Returns the associated markups node
  vtkMRMLMarkupsNode* mrmlMarkupsNode();


public slots:

  /// Sets the vtkMRMLMarkupsNode to operate on.
  virtual void setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode);

  /// Sets the vtkMRMLMarkupsNode to operate on.
  virtual void setMRMLMarkupsNode(vtkMRMLNode* markupsNode);

protected:
  /// This constructor allows subclasses to initialize with their own concrete Private
  qMRMLMarkupsAdditionalOptionsWidget(qMRMLMarkupsAdditionalOptionsWidgetPrivate &d, QWidget* parent=nullptr);
  QScopedPointer<qMRMLMarkupsAdditionalOptionsWidgetPrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qMRMLMarkupsAdditionalOptionsWidget);
  Q_DISABLE_COPY(qMRMLMarkupsAdditionalOptionsWidget);
};

#endif // __qslicermarkupsadditionalwidget_h_
