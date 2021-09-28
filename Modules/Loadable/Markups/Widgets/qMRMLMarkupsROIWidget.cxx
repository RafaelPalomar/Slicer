/*==============================================================================

  Program: 3D Slicer

  Copyright (c) Kitware Inc.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Kyle Sunderland, PerkLab, Queen's University
  and was supported through CANARIE's Research Software Program, Cancer
  Care Ontario, OpenAnatomy, and Brigham and Women's Hospital through NIH grant R01MH112748.

  ==============================================================================*/

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget_p.h"

// qMRML includes
#include "qMRMLMarkupsROIWidget.h"
#include "ui_qMRMLMarkupsROIWidget.h"

// MRML includes
#include <vtkMRMLMarkupsROINode.h>
#include <vtkMRMLDisplayNode.h>

// VTK includes
#include <vtkWeakPointer.h>

// STD includes
#include <vector>

// 0.001 because the sliders only handle 2 decimals
#define SLIDERS_EPSILON 0.001

// --------------------------------------------------------------------------
class qMRMLMarkupsROIWidgetPrivate:
  public Ui_qMRMLMarkupsROIWidget
{
  Q_DECLARE_PUBLIC(qMRMLMarkupsROIWidget);

protected:
  qMRMLMarkupsROIWidget* const q_ptr;

public:
  qMRMLMarkupsROIWidgetPrivate(qMRMLMarkupsROIWidget* object);
  void setupUi(qMRMLMarkupsROIWidget* widget);

  vtkWeakPointer<vtkMRMLMarkupsROINode> MarkupsROINode;
  bool IsProcessingOnMRMLNodeModified;
  bool AutoRange;
};

// --------------------------------------------------------------------------
qMRMLMarkupsROIWidgetPrivate::qMRMLMarkupsROIWidgetPrivate(qMRMLMarkupsROIWidget* object)
  : q_ptr(object), MarkupsROINode(nullptr)
{
  this->IsProcessingOnMRMLNodeModified = false;
  this->AutoRange = true;
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidgetPrivate::setupUi(qMRMLMarkupsROIWidget* widget)
{
  Q_Q(qMRMLMarkupsROIWidget);

  this->Ui_qMRMLMarkupsROIWidget::setupUi(widget);

  this->roiTypeComboBox->clear();
  for (int roiType = 0; roiType < vtkMRMLMarkupsROINode::ROIType_Last; ++roiType)
    {
    this->roiTypeComboBox->addItem(vtkMRMLMarkupsROINode::GetROITypeAsString(roiType), roiType);
    }

  QObject::connect(this->roiTypeComboBox, SIGNAL(currentIndexChanged(int)),
                   q, SLOT(onROITypeParameterChanged()));
  QObject::connect(this->DisplayClippingBoxButton, SIGNAL(toggled(bool)),
                   q, SLOT(setDisplayClippingBox(bool)));
  QObject::connect(this->InteractiveModeCheckBox, SIGNAL(toggled(bool)),
                   q, SLOT(setInteractiveMode(bool)));
  QObject::connect(this->LRRangeWidget, SIGNAL(valuesChanged(double,double)),
                   q, SLOT(updateROI()));
  QObject::connect(this->PARangeWidget, SIGNAL(valuesChanged(double,double)),
                   q, SLOT(updateROI()));
  QObject::connect(this->ISRangeWidget, SIGNAL(valuesChanged(double,double)),
                   q, SLOT(updateROI()));
  q->setEnabled(this->MarkupsROINode != nullptr);
}

// --------------------------------------------------------------------------
// qMRMLMarkupsROIWidget methods

// --------------------------------------------------------------------------
qMRMLMarkupsROIWidget:: qMRMLMarkupsROIWidget(QWidget* parent)
  : Superclass(parent),
    d_ptr(new qMRMLMarkupsROIWidgetPrivate(this))
{
  this->setup();
}

// --------------------------------------------------------------------------
qMRMLMarkupsROIWidget::~qMRMLMarkupsROIWidget() = default;

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setup()
{
  Q_D(qMRMLMarkupsROIWidget);
  d->setupUi(this);
}

// --------------------------------------------------------------------------
vtkMRMLMarkupsROINode* qMRMLMarkupsROIWidget::mrmlROINode()const
{
  Q_D(const qMRMLMarkupsROIWidget);
  return vtkMRMLMarkupsROINode::SafeDownCast(d->MarkupsROINode);
}


// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::onMRMLNodeModified()
{
  Q_D(qMRMLMarkupsROIWidget);

  vtkMRMLMarkupsROINode* roiNode = vtkMRMLMarkupsROINode::SafeDownCast(d->MarkupsROINode);
  if (!roiNode)
    {
    return;
    }

  d->IsProcessingOnMRMLNodeModified = true;

  // Interactive Mode
  bool interactive = false;
  if (roiNode->GetDisplayNode())
    {
    interactive = vtkMRMLMarkupsDisplayNode::SafeDownCast(roiNode->GetDisplayNode())->GetHandlesInteractive();
    }
  d->LRRangeWidget->setTracking(interactive);
  d->PARangeWidget->setTracking(interactive);
  d->ISRangeWidget->setTracking(interactive);
  d->InteractiveModeCheckBox->setChecked(interactive);

  // ROI
  double xyz[3];
  double rxyz[3];

  roiNode->GetXYZ(xyz);
  roiNode->GetRadiusXYZ(rxyz);

  double bounds[6];
  for (int i=0; i < 3; ++i)
    {
    bounds[i]   = xyz[i]-rxyz[i];
    bounds[3+i] = xyz[i]+rxyz[i];
    }

  if (d->AutoRange)
    {
    d->LRRangeWidget->setRange(
      qMin(bounds[0], d->LRRangeWidget->minimum()),
      qMax(bounds[3], d->LRRangeWidget->maximum()));
    d->PARangeWidget->setRange(
      qMin(bounds[1], d->PARangeWidget->minimum()),
      qMax(bounds[4], d->PARangeWidget->maximum()));
    d->ISRangeWidget->setRange(
      qMin(bounds[2], d->ISRangeWidget->minimum()),
      qMax(bounds[5], d->ISRangeWidget->maximum()));
    }

  d->LRRangeWidget->setValues(bounds[0], bounds[3]);
  d->PARangeWidget->setValues(bounds[1], bounds[4]);
  d->ISRangeWidget->setValues(bounds[2], bounds[5]);

  d->IsProcessingOnMRMLNodeModified = false;
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setExtent(double min, double max)
{
  this->setExtent(min, max, min, max, min, max);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setExtent(double minLR, double maxLR,
                                        double minPA, double maxPA,
                                        double minIS, double maxIS)
{
  Q_D(qMRMLMarkupsROIWidget);
  d->LRRangeWidget->setRange(minLR, maxLR);
  d->PARangeWidget->setRange(minPA, maxPA);
  d->ISRangeWidget->setRange(minIS, maxIS);
}


// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setDisplayClippingBox(bool visible)
{
  Q_D(qMRMLMarkupsROIWidget);

  int numberOfDisplayNodes = d->MarkupsROINode->GetNumberOfDisplayNodes();

  std::vector<int> wasModifying(numberOfDisplayNodes);
  for(int index = 0; index < numberOfDisplayNodes; index++)
    {
    vtkMRMLDisplayNode* displayNode = d->MarkupsROINode->GetNthDisplayNode(index);
    if (!displayNode)
      {
      continue;
      }
    wasModifying[index] = displayNode->StartModify();
    }

  d->MarkupsROINode->SetDisplayVisibility(visible);

  for(int index = 0; index < numberOfDisplayNodes; index++)
    {
    vtkMRMLDisplayNode* displayNode = d->MarkupsROINode->GetNthDisplayNode(index);
    if (!displayNode)
      {
      continue;
      }
    displayNode->EndModify(wasModifying[index]);
    }
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setInteractiveMode(bool interactive)
{
  Q_D(qMRMLMarkupsROIWidget);
  if (!d->MarkupsROINode->GetDisplayNode())
    {
    d->MarkupsROINode->CreateDefaultDisplayNodes();
    }
  vtkMRMLMarkupsDisplayNode::SafeDownCast(d->MarkupsROINode->GetDisplayNode())->SetHandlesInteractive(interactive);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::updateROI()
{
  Q_D(qMRMLMarkupsROIWidget);

  // Ignore the calls from onMRMLNodeModified() as it
  // could set the node in an inconsistent state (except for
  // ISRangeWidget->setValues()).
  if (d->IsProcessingOnMRMLNodeModified)
    {
    return;
    }

  vtkMRMLMarkupsROINode* roiNode = vtkMRMLMarkupsROINode::SafeDownCast(d->MarkupsROINode);
  if (!roiNode)
    {
    return;
    }

  double bounds[6];
  d->LRRangeWidget->values(bounds[0],bounds[1]);
  d->PARangeWidget->values(bounds[2],bounds[3]);
  d->ISRangeWidget->values(bounds[4],bounds[5]);

  MRMLNodeModifyBlocker blocker(roiNode);
  roiNode->SetXYZ(0.5*(bounds[1]+bounds[0]),
                  0.5*(bounds[3]+bounds[2]),
                  0.5*(bounds[5]+bounds[4]));
  roiNode->SetRadiusXYZ(0.5*(bounds[1]-bounds[0]),
                        0.5*(bounds[3]-bounds[2]),
                        0.5*(bounds[5]-bounds[4]));
}


// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setMRMLMarkupsNode(vtkMRMLMarkupsNode* markupsNode)
{
  Q_D(qMRMLMarkupsROIWidget);


  this->qvtkReconnect(d->MarkupsROINode, markupsNode, vtkCommand::ModifiedEvent,
                      this, SLOT(onMRMLNodeModified()));

  this->qvtkReconnect(d->MarkupsROINode, markupsNode, vtkMRMLDisplayableNode::DisplayModifiedEvent,
                      this, SLOT(onMRMLDisplayNodeModified()));

  d->MarkupsROINode = vtkMRMLMarkupsROINode::SafeDownCast(markupsNode);

  this->onMRMLNodeModified();
  this->onMRMLDisplayNodeModified();
  this->setEnabled(markupsNode != nullptr);
}

// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::setMRMLMarkupsNode(vtkMRMLNode* node)
{
  this->setMRMLMarkupsNode(vtkMRMLMarkupsROINode::SafeDownCast(node));
}
// --------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::onMRMLDisplayNodeModified()
{
  Q_D(qMRMLMarkupsROIWidget);

  if (!d->MarkupsROINode)
    {
    return;
    }

  // Visibility
  d->DisplayClippingBoxButton->setChecked(d->MarkupsROINode->GetDisplayVisibility());
}

//-----------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::onROITypeParameterChanged()
{
  Q_D(qMRMLMarkupsROIWidget);
  vtkMRMLMarkupsROINode* roiNode = vtkMRMLMarkupsROINode::SafeDownCast(d->MarkupsROINode);
  if (!roiNode)
    {
    return;
    }
  MRMLNodeModifyBlocker blocker(roiNode);
  roiNode->SetROIType(d->roiTypeComboBox->currentData().toInt());
}

//-----------------------------------------------------------------------------
void qMRMLMarkupsROIWidget::updateWidgetFromMRML()
{
  Q_D(qMRMLMarkupsROIWidget);

  vtkMRMLMarkupsROINode* markupsROINode = vtkMRMLMarkupsROINode::SafeDownCast(d->MarkupsROINode);
  if (markupsROINode)
    {
    bool wasBlocked = d->roiTypeComboBox->blockSignals(true);
    d->roiTypeComboBox->setCurrentIndex(d->roiTypeComboBox->findData(markupsROINode->GetROIType()));
    d->roiTypeComboBox->blockSignals(wasBlocked);
    this->setMRMLMarkupsNode(markupsROINode);
    }
}

//-----------------------------------------------------------------------------
bool qMRMLMarkupsROIWidget::canManageMRMLMarkupsNode(vtkMRMLMarkupsNode *markupsNode) const
{
  Q_D(const qMRMLMarkupsROIWidget);

  vtkMRMLMarkupsROINode* roiNode = vtkMRMLMarkupsROINode::SafeDownCast(markupsNode);
  if (!roiNode)
    {
    return false;
    }

  return true;
}
