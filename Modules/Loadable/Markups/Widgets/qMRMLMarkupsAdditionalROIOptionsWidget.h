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

#ifndef qMRMLMarkupsAdditionalROIOptionsWidget_h_
#define qMRMLMarkupsAdditionalROIOptionsWidget_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qSlicerMarkupsModuleWidgetsExport.h"

//-----------------------------------------------------------------------------
class qMRMLMarkupsAdditionalROIOptionsWidgetPrivate;

//-----------------------------------------------------------------------------
class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT qMRMLMarkupsAdditionalROIOptionsWidget : public qMRMLMarkupsAdditionalOptionsWidget
{
  Q_OBJECT
  QVTK_OBJECT

public:
  typedef qMRMLMarkupsAdditionalOptionsWidget Superclass;
  qMRMLMarkupsAdditionalROIOptionsWidget(QWidget* parent=nullptr);
  ~qMRMLMarkupsAdditionalROIOptionsWidget() override;

  /// Updates the widget based on information from MRML.
  void updateWidgetFromMRML() override;

  /// Gets the name of the additional options widget type
  const QString getAdditionalOptionsWidgetTypeName() override { return "ROI"; }

public slots:
  /// Set the MRML node of interest
  void setMRMLMarkupsNode(vtkMRMLMarkupsNode* node) override;
  /// Sets the vtkMRMLMarkupsNode to operate on.
  void setMRMLMarkupsNode(vtkMRMLNode* node) override;

protected:
  qMRMLMarkupsAdditionalROIOptionsWidget(qMRMLMarkupsAdditionalROIOptionsWidgetPrivate &d, QWidget* parent=nullptr);
  void setup();

protected:
  QScopedPointer<qMRMLMarkupsAdditionalROIOptionsWidgetPrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qMRMLMarkupsAdditionalROIOptionsWidget);
  Q_DISABLE_COPY(qMRMLMarkupsAdditionalROIOptionsWidget);
};
#endif // qMRMLadditionalROIOptionsWidget_h_
