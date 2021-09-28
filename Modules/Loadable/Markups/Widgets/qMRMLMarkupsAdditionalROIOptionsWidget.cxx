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

#include "qMRMLMarkupsAdditionalROIOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

#include "ui_qMRMLMarkupsAdditionalROIOptionsWidget.h"

// MRML Node includes
#include <vtkMRMLMarkupsROINode.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAdditionalROIOptionsWidgetPrivate:
  public qMRMLMarkupsAdditionalOptionsWidgetPrivate,
  public Ui_qMRMLMarkupsAdditionalROIOptionsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAdditionalROIOptionsWidget);

protected:
  qMRMLMarkupsAdditionalROIOptionsWidget* const q_ptr;

public:
  qMRMLMarkupsAdditionalROIOptionsWidgetPrivate(qMRMLMarkupsAdditionalROIOptionsWidget* object);
  void setupUi(qMRMLMarkupsAdditionalROIOptionsWidget* widget);
};

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalROIOptionsWidgetPrivate::
qMRMLMarkupsAdditionalROIOptionsWidgetPrivate(qMRMLMarkupsAdditionalROIOptionsWidget* object)
  : q_ptr(object), qMRMLMarkupsAdditionalOptionsWidgetPrivate()
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalROIOptionsWidgetPrivate::setupUi(qMRMLMarkupsAdditionalROIOptionsWidget* widget)
{
  Q_Q(qMRMLMarkupsAdditionalROIOptionsWidget);

  this->Ui_qMRMLMarkupsAdditionalROIOptionsWidget::setupUi(widget);

  // Hidden by default. It is meant to show up only in the right context (only
  // when the appropriated node type is selected)
  this->MarkupsROIWidget->setVisible(false);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalROIOptionsWidget::qMRMLMarkupsAdditionalROIOptionsWidget(QWidget* parent)
  :Superclass(parent),
   d_ptr(new qMRMLMarkupsAdditionalROIOptionsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalROIOptionsWidget::setup()
{
  Q_D(qMRMLMarkupsAdditionalROIOptionsWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalROIOptionsWidget::~qMRMLMarkupsAdditionalROIOptionsWidget()=default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalROIOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalROIOptionsWidget);

  d->MarkupsNode = markupsNode;
  d->MarkupsROIWidget->setMRMLMarkupsNode(markupsNode);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalROIOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsROINode::SafeDownCast(node));
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalROIOptionsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAdditionalROIOptionsWidget);

  d->MarkupsROIWidget->updateWidgetFromMRML();

  if (!d->MarkupsROIWidget->canManageMRMLMarkupsNode(d->MarkupsNode))
    {
    d->MarkupsROIWidget->setVisible(false);
    return;
    }

  d->MarkupsROIWidget->setVisible(true);
}

