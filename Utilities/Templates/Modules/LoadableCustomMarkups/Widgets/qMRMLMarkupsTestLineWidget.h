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

#ifndef __qSlicerTestLineWidget_h_
#define __qSlicerTestLineWidget_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qSlicerTemplateKeyModuleWidgetsExport.h"

class qMRMLMarkupsTestLineWidgetPrivate;
class vtkMRMLMarkupsNode;

class Q_SLICER_MODULE_TEMPLATEKEY_WIDGETS_EXPORT
qMRMLMarkupsTestLineWidget : public QWidget
{
  Q_OBJECT

public:

  typedef QWidget Superclass;
  qMRMLMarkupsTestLineWidget(QWidget* parent=nullptr);
  ~qMRMLMarkupsTestLineWidget() override;

  /// Updates the widget based on information from MRML.
  void updateWidgetFromMRML();

  /// Checks whether a given node can be handled by the widget
  bool canManageMRMLMarkupsNode(vtkMRMLMarkupsNode *markupsNode) const;

public slots:
/// Set the MRML node of interest
  void setMRMLMarkupsNode(vtkMRMLMarkupsNode* node);
  /// Sets the vtkMRMLMarkupsNode to operate on.
  void setMRMLMarkupsNode(vtkMRMLNode* node);


protected:
  void setup();

protected:
  QScopedPointer<qMRMLMarkupsTestLineWidgetPrivate> d_ptr;

private:
  Q_DECLARE_PRIVATE(qMRMLMarkupsTestLineWidget);
  Q_DISABLE_COPY(qMRMLMarkupsTestLineWidget);
};

#endif // __qSlicerTestLineWidget_h_
