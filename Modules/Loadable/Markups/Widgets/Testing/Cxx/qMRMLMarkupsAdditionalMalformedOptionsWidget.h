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

#ifndef qMRMLMarkupsAdditionalMalformedOptionsWidget_h_
#define qMRMLMarkupsAdditionalMalformedOptionsWidget_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qSlicerMarkupsModuleWidgetsExport.h"

//-----------------------------------------------------------------------------
class qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate;

//-----------------------------------------------------------------------------
class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT qMRMLMarkupsAdditionalMalformedOptionsWidget : public qMRMLMarkupsAdditionalOptionsWidget
{
  Q_OBJECT
  QVTK_OBJECT

public:
  typedef qMRMLMarkupsAdditionalOptionsWidget Superclass;
  qMRMLMarkupsAdditionalMalformedOptionsWidget(QWidget* parent=nullptr);
  ~qMRMLMarkupsAdditionalMalformedOptionsWidget() override;

  /// Updates the widget based on information from MRML.
  void updateWidgetFromMRML() override;

  /// Gets the name of the additional options widget type
  const QString getAdditionalOptionsWidgetTypeName() override { return "Malformed"; }

public slots:
  /// Set the MRML node of interest
  void setMRMLMarkupsNode(vtkMRMLMarkupsNode* node) override;
  /// Sets the vtkMRMLMarkupsNode to operate on.
  void setMRMLMarkupsNode(vtkMRMLNode* node) override;

protected:
  qMRMLMarkupsAdditionalMalformedOptionsWidget(qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate &d, QWidget* parent=nullptr);
  void setup();

protected:
  QScopedPointer<qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qMRMLMarkupsAdditionalMalformedOptionsWidget);
  Q_DISABLE_COPY(qMRMLMarkupsAdditionalMalformedOptionsWidget);
};
#endif // qMRMLadditionalMalformedOptionsWidget_h_
