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

#include "qMRMLMarkupsAdditionalMalformedOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

#include "ui_qMRMLMarkupsAdditionalMalformedOptionsWidget.h"

// MRML Node includes
#include <vtkMRMLMarkupsLineNode.h>

// --------------------------------------------------------------------------
class qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate:
  public qMRMLMarkupsAdditionalOptionsWidgetPrivate,
  public Ui_qMRMLMarkupsAdditionalMalformedOptionsWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsAdditionalMalformedOptionsWidget);

protected:
  qMRMLMarkupsAdditionalMalformedOptionsWidget* const q_ptr;

public:
  qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate(qMRMLMarkupsAdditionalMalformedOptionsWidget* object);
  void setupUi(qMRMLMarkupsAdditionalMalformedOptionsWidget* widget);
};

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate::
qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate(qMRMLMarkupsAdditionalMalformedOptionsWidget* object)
  : q_ptr(object), qMRMLMarkupsAdditionalOptionsWidgetPrivate()
{

}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate::setupUi(qMRMLMarkupsAdditionalMalformedOptionsWidget* widget)
{
  Q_Q(qMRMLMarkupsAdditionalMalformedOptionsWidget);

  this->Ui_qMRMLMarkupsAdditionalMalformedOptionsWidget::setupUi(widget);

  // Hidden by default. It is meant to show up only in the right context (only
  // when the appropriated node type is selected)
  this->MarkupsMalformedWidget->setVisible(false);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalMalformedOptionsWidget::qMRMLMarkupsAdditionalMalformedOptionsWidget(QWidget* parent)
  :Superclass(parent),
   d_ptr(new qMRMLMarkupsAdditionalMalformedOptionsWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalMalformedOptionsWidget::setup()
{
  Q_D(qMRMLMarkupsAdditionalMalformedOptionsWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
qMRMLMarkupsAdditionalMalformedOptionsWidget::~qMRMLMarkupsAdditionalMalformedOptionsWidget()=default;

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalMalformedOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalMalformedOptionsWidget);

  d->MarkupsNode = markupsNode;
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalMalformedOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsLineNode::SafeDownCast(node));
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalMalformedOptionsWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsAdditionalMalformedOptionsWidget);

  d->MarkupsMalformedWidget->updateWidgetFromMRML();

  if (!d->MarkupsMalformedWidget->canManageMRMLMarkupsNode(d->MarkupsNode))
    {
    d->MarkupsMalformedWidget->setVisible(false);
    return;
    }

  d->MarkupsMalformedWidget->setVisible(true);
}

