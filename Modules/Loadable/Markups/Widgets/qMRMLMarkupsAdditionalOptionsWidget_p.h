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

#ifndef __qslicermarkupsadditionalwidget_p_h_
#define __qslicermarkupsadditionalwidget_p_h_

// Qt includes
#include <QObject>

// Markups Widgets includes
#include "qSlicerMarkupsModuleWidgetsExport.h"

// VTK includes
#include <vtkWeakPointer.h>

//-----------------------------------------------------------------------------
class QStringList;
class qMRMLMarkupsAdditionalOptionsWidget;
class vtkMRMLMarkupsNode;

//-----------------------------------------------------------------------------
class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT qMRMLMarkupsAdditionalOptionsWidgetPrivate
  : public QObject
{

public:
  typedef QObject Superclass;
  qMRMLMarkupsAdditionalOptionsWidgetPrivate();
  ~qMRMLMarkupsAdditionalOptionsWidgetPrivate()=default;

  // Internal reference to node to operate on
  vtkWeakPointer<vtkMRMLMarkupsNode> MarkupsNode;
};

#endif // __qslicermarkupsadditionalwidget_p_h_
