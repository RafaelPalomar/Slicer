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

#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qMRMLMarkupsAdditionalOptionsWidget_p.h"

// Qt includes
#include <QDebug>

// MRML includes
#include "vtkMRMLMarkupsNode.h"

//-----------------------------------------------------------------------------
// qMRMLMarkupsAdditionalOptionsWidgetmethods

qMRMLMarkupsAdditionalOptionsWidgetPrivate:: qMRMLMarkupsAdditionalOptionsWidgetPrivate()
  : MarkupsNode(nullptr)
{

}

//-----------------------------------------------------------------------------
// qMRMLMarkupsAdditionalOptionsWidgetmethods

//-----------------------------------------------------------------------------
qMRMLMarkupsAdditionalOptionsWidget::
qMRMLMarkupsAdditionalOptionsWidget(QWidget* parent)
  : Superclass(parent), d_ptr(new qMRMLMarkupsAdditionalOptionsWidgetPrivate)
{

}

//-----------------------------------------------------------------------------
qMRMLMarkupsAdditionalOptionsWidget::
qMRMLMarkupsAdditionalOptionsWidget(qMRMLMarkupsAdditionalOptionsWidgetPrivate &d, QWidget* parent)
  : Superclass(parent), d_ptr(&d)
{

}

// --------------------------------------------------------------------------
vtkMRMLMarkupsNode* qMRMLMarkupsAdditionalOptionsWidget::mrmlMarkupsNode()
{
  Q_D(qMRMLMarkupsAdditionalOptionsWidget);

  return d->MarkupsNode;
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalOptionsWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsAdditionalOptionsWidget);

  d->MarkupsNode = markupsNode;
}

// --------------------------------------------------------------------------
void qMRMLMarkupsAdditionalOptionsWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  Q_D(qMRMLMarkupsAdditionalOptionsWidget);

  this->setMRMLMarkupsNode(vtkMRMLMarkupsNode::SafeDownCast(node));
}
