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

#ifndef __qMRMLMarkupsAngleMeasurementsWidget_h_
#define __qMRMLMarkupsAngleMeasurementsWidget_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qSlicerMarkupsModuleWidgetsExport.h"

class qMRMLMarkupsAngleMeasurementsWidgetPrivate;
class vtkMRMLMarkupsNode;

class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT
qMRMLMarkupsAngleMeasurementsWidget : public QWidget
{
  Q_OBJECT
  QVTK_OBJECT

public:

  typedef QWidget Superclass;
  qMRMLMarkupsAngleMeasurementsWidget(QWidget* parent=nullptr);
  ~qMRMLMarkupsAngleMeasurementsWidget() override;

  /// Updates the widget based on information from MRML.
  void updateWidgetFromMRML();

  /// Gets the name of the additional options widget type
  const QString getAdditionalOptionsWidgetTypeName() { return "AngleMeasurements"; }

  /// Checks whether a given node can be handled by the widget
  bool canManageMRMLMarkupsNode(vtkMRMLMarkupsNode *markupsNode) const;

public slots:
  /// Set the MRML node of interest
  void setMRMLMarkupsNode(vtkMRMLMarkupsNode* node);
  /// Sets the vtkMRMLMarkupsNode to operate on.
  void setMRMLMarkupsNode(vtkMRMLNode* node);

  /// Change angle mode of current angle markup if combobox selection is made.
  void onAngleMeasurementModeChanged();
  /// Update angle measurement rotation axis if the user edits the column vector
  void onRotationAxisChanged();

protected:
  void setup();

protected:
  QScopedPointer<qMRMLMarkupsAngleMeasurementsWidgetPrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qMRMLMarkupsAngleMeasurementsWidget);
  Q_DISABLE_COPY(qMRMLMarkupsAngleMeasurementsWidget);
};

#endif // __qMRMLMarkupsAngleMeasurementsWidget_h_
