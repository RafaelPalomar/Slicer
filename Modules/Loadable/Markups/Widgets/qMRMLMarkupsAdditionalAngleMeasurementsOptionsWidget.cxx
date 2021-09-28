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

#include "qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

#include "ui_qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget.h"

// MRML Node includes
#include <vtkMRMLMarkupsAngleNode.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate:
  public qMRMLMarkupsAdditionalOptionsWidgetPrivate,
  public Ui_qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);

protected:
  qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget* const q_ptr;

public:
  qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget* object);
  void setupUi(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget* widget);
};

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate::
qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget* object)
  : q_ptr(object),qMRMLMarkupsAdditionalOptionsWidgetPrivate()
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate::setupUi(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget* widget)
{
  Q_Q(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);

  this->Ui_qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::setupUi(widget);

  // Hidden by default. It is meant to show up only in the right context (only
  // when the appropriated node type is selected)
  this->MarkupsAngleMeasurementsWidget->setVisible(false);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget(QWidget* parent)
  :Superclass(parent),
   d_ptr(new qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::setup()
{
  Q_D(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::~qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget()=default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);

  d->MarkupsNode = markupsNode;
  d->MarkupsAngleMeasurementsWidget->setMRMLMarkupsNode(markupsNode);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsAngleNode::SafeDownCast(node));
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);

  d->MarkupsAngleMeasurementsWidget->updateWidgetFromMRML();

  if (!d->MarkupsAngleMeasurementsWidget->canManageMRMLMarkupsNode(d->MarkupsNode))
    {
    d->MarkupsAngleMeasurementsWidget->setVisible(false);
    return;
    }

  d->MarkupsAngleMeasurementsWidget->setVisible(true);
}
