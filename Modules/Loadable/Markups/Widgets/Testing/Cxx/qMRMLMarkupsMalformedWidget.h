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

#ifndef __qMRMLMalformedWidget_h_
#define __qMRMLMalformedWidget_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"

//------------------------------------------------------------------------------
class qMRMLMarkupsMalformedWidgetPrivate;
class vtkMRMLMarkupsNode;

//------------------------------------------------------------------------------
class qMRMLMarkupsMalformedWidget : public QWidget
{
  Q_OBJECT

public:
  typedef QWidget Superclass;
  qMRMLMarkupsMalformedWidget(QWidget* parent=nullptr);

  void updateWidgetFromMRML() {}
  bool canManageMRMLMarkupsNode(vtkMRMLMarkupsNode *) const {return false;}
};

#endif // __qMRMLMalformedWidget_h_
