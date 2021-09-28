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

#include "qMRMLMarkupsAdditionalTestLineOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

#include "ui_qMRMLMarkupsAdditionalTestLineOptionsWidget.h"

// MRML Node includes
#include <vtkMRMLMarkupsTestLineNode.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate:
  public qMRMLMarkupsAdditionalOptionsWidgetPrivate,
  public Ui_qMRMLMarkupsAdditionalTestLineOptionsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAdditionalTestLineOptionsWidget);

protected:
  qMRMLMarkupsAdditionalTestLineOptionsWidget* const q_ptr;

public:
  qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate(qMRMLMarkupsAdditionalTestLineOptionsWidget* object);
  void setupUi(qMRMLMarkupsAdditionalTestLineOptionsWidget* widget);
};

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate::
qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate(qMRMLMarkupsAdditionalTestLineOptionsWidget* object)
  : q_ptr(object), qMRMLMarkupsAdditionalOptionsWidgetPrivate()
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate::setupUi(qMRMLMarkupsAdditionalTestLineOptionsWidget* widget)
{
  Q_Q(qMRMLMarkupsAdditionalTestLineOptionsWidget);

  this->Ui_qMRMLMarkupsAdditionalTestLineOptionsWidget::setupUi(widget);

  // Hidden by default. It is meant to show up only in the right context (only
  // when the appropriated node type is selected)
  this->MarkupsTestLineWidget->setVisible(false);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalTestLineOptionsWidget::qMRMLMarkupsAdditionalTestLineOptionsWidget(QWidget* parent)
  :Superclass(parent),
   d_ptr(new qMRMLMarkupsAdditionalTestLineOptionsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalTestLineOptionsWidget::setup()
{
  Q_D(qMRMLMarkupsAdditionalTestLineOptionsWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalTestLineOptionsWidget::~qMRMLMarkupsAdditionalTestLineOptionsWidget()=default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalTestLineOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalTestLineOptionsWidget);

  d->MarkupsNode = markupsNode;
  d->MarkupsTestLineWidget->setMRMLMarkupsNode(markupsNode);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalTestLineOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsTestLineNode::SafeDownCast(node));
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalTestLineOptionsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAdditionalTestLineOptionsWidget);

  d->MarkupsTestLineWidget->updateWidgetFromMRML();

  if (!d->MarkupsTestLineWidget->canManageMRMLMarkupsNode(d->MarkupsNode))
    {
    d->MarkupsTestLineWidget->setVisible(false);
    return;
    }

  d->MarkupsTestLineWidget->setVisible(true);
}

