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

#include "qMRMLMarkupsAdditionalCurveSettingsOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

#include "ui_qMRMLMarkupsAdditionalCurveSettingsOptionsWidget.h"

// MRML Node includes
#include <vtkMRMLMarkupsCurveNode.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate:
  public qMRMLMarkupsAdditionalOptionsWidgetPrivate,
  public Ui_qMRMLMarkupsAdditionalCurveSettingsOptionsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);

protected:
  qMRMLMarkupsAdditionalCurveSettingsOptionsWidget* const q_ptr;

public:
  qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget* object);
  void setupUi(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget* widget);
};

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate::
qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget* object)
  : q_ptr(object)
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate::setupUi(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget* widget)
{
  Q_Q(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);

  this->Ui_qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::setupUi(widget);

  // Hidden by default. It is meant to show up only in the right context (only
  // when the appropriated node type is selected)
  this->MarkupsCurveSettingsWidget->setVisible(false);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::qMRMLMarkupsAdditionalCurveSettingsOptionsWidget(QWidget* parent)
  :Superclass(parent),
   d_ptr(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::setup()
{
  Q_D(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::~qMRMLMarkupsAdditionalCurveSettingsOptionsWidget()=default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);

  d->MarkupsNode = markupsNode;
  d->MarkupsCurveSettingsWidget->setMRMLMarkupsNode(markupsNode);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsCurveNode::SafeDownCast(node));
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalCurveSettingsOptionsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);

  d->MarkupsCurveSettingsWidget->updateWidgetFromMRML();

  if (!d->MarkupsCurveSettingsWidget->canManageMRMLMarkupsNode(d->MarkupsNode))
    {
    d->MarkupsCurveSettingsWidget->setVisible(false);
    return;
    }

  d->MarkupsCurveSettingsWidget->setVisible(true);
}

