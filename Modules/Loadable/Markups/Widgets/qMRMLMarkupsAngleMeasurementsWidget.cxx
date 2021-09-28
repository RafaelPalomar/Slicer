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

#include "qMRMLMarkupsAngleMeasurementsWidget.h"
#include "ui_qMRMLMarkupsAngleMeasurementsWidget.h"

// MRML Markups includes
#include <vtkMRMLMarkupsNode.h>
#include <vtkMRMLMarkupsAngleNode.h>

// VTK includes
#include <vtkWeakPointer.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAngleMeasurementsWidgetPrivate:
  public Ui_qMRMLMarkupsAngleMeasurementsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAngleMeasurementsWidget);

protected:
  qMRMLMarkupsAngleMeasurementsWidget* const q_ptr;

public:
  qMRMLMarkupsAngleMeasurementsWidgetPrivate(qMRMLMarkupsAngleMeasurementsWidget* object);
  void setupUi(qMRMLMarkupsAngleMeasurementsWidget*);

  vtkWeakPointer<vtkMRMLMarkupsAngleNode> MarkupsAngleNode;
};

// --------------------------------------------------------------------------
qMRMLMarkupsAngleMeasurementsWidgetPrivate::
qMRMLMarkupsAngleMeasurementsWidgetPrivate(qMRMLMarkupsAngleMeasurementsWidget* object)
  : q_ptr(object), MarkupsAngleNode(nullptr)
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidgetPrivate::setupUi(qMRMLMarkupsAngleMeasurementsWidget* widget)
{
  Q_Q(qMRMLMarkupsAngleMeasurementsWidget);

  this->Ui_qMRMLMarkupsAngleMeasurementsWidget::setupUi(widget);

  QObject::connect(this->angleMeasurementModeComboBox, SIGNAL(currentIndexChanged(int)),
                   q, SLOT(onAngleMeasurementModeChanged()));
  QObject::connect(this->rotationAxisCoordinatesWidget, SIGNAL(coordinatesChanged(double*)),
                   q, SLOT(onRotationAxisChanged()));

  q->setEnabled(this->MarkupsAngleNode != nullptr);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAngleMeasurementsWidget::
qMRMLMarkupsAngleMeasurementsWidget(QWidget *parent)
  : Superclass(parent),
    d_ptr(new qMRMLMarkupsAngleMeasurementsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
qMRMLMarkupsAngleMeasurementsWidget::~qMRMLMarkupsAngleMeasurementsWidget() = default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::setup()
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);
  d->setupUi(this);
}
// --------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);

  if (d->MarkupsAngleNode)
    {
    // double axisVector[3] = {0.0, 0.0, 0.0};
    // d->MarkupsAngleNode->GetOrientationRotationAxis(axisVector);
    // bool wasBlocked = d->rotationAxisCoordinatesWidget->blockSignals(true);
    // d->rotationAxisCoordinatesWidget->setCoordinates(axisVector);
    // d->rotationAxisCoordinatesWidget->blockSignals(wasBlocked);
    // d->rotationAxisCoordinatesWidget->setEnabled(d->MarkupsAngleNode->GetAngleMeasurementMode() != vtkMRMLMarkupsAngleNode::Minimal);
    }
}

//-----------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::onAngleMeasurementModeChanged()
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);
  vtkMRMLMarkupsAngleNode* markupsAngleNode = vtkMRMLMarkupsAngleNode::SafeDownCast(d->MarkupsAngleNode);
  if (!markupsAngleNode)
    {
    return;
    }

  markupsAngleNode->SetAngleMeasurementMode(d->angleMeasurementModeComboBox->currentIndex());
}

//-----------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::onRotationAxisChanged()
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);

  vtkMRMLMarkupsAngleNode* markupsAngleNode = vtkMRMLMarkupsAngleNode::SafeDownCast(d->MarkupsAngleNode);
  if (!markupsAngleNode)
    {
    return;
    }
  markupsAngleNode->SetOrientationRotationAxis(const_cast<double*>(d->rotationAxisCoordinatesWidget->coordinates()));
}

//-----------------------------------------------------------------------------
bool qMRMLMarkupsAngleMeasurementsWidget::canManageMRMLMarkupsNode(vtkMRMLMarkupsNode *markupsNode) const
{
  Q_D(const qMRMLMarkupsAngleMeasurementsWidget);

  vtkMRMLMarkupsAngleNode* angleNode = vtkMRMLMarkupsAngleNode::SafeDownCast(markupsNode);
  if (!angleNode)
    {
    return false;
    }

  return true;
}
// --------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);

  d->MarkupsAngleNode = vtkMRMLMarkupsAngleNode::SafeDownCast(markupsNode);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAngleMeasurementsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  Q_D(qMRMLMarkupsAngleMeasurementsWidget);

  this->setMRMLMarkupsNode(vtkMRMLMarkupsAngleNode::SafeDownCast(node));
}
