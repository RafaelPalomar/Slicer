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
  Oslo University Hospital), based on qMRMLMarkupsAdditionalOptionsWidgetsFactory.h by
  Csaba Pinter (Perklab, Queen's University), and was supported by The Research
  Council of Norway through the ALive project (grant nr. 311393).

  ==============================================================================*/

#ifndef __qslicermarkupsfactory_h_
#define __qslicermarkupsfactory_h_

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidget.h"
#include "qSlicerMarkupsModuleWidgetsExport.h"

// Qt includes
#include <QObject>
#include <QList>
#include <QPointer>

class qMRMLMarkupsAdditionalOptionsWidget;
class qMRMLMarkupsAdditionalOptionsWidgetsFactoryCleanup;

/// \ingroup SlicerRt_QtModules_Segmentations
/// \class qMRMLMarkupsAdditionalOptionsWidgetsFactory
/// \brief Singleton class managing segment editor effect plugins
class Q_SLICER_MODULE_MARKUPS_WIDGETS_EXPORT qMRMLMarkupsAdditionalOptionsWidgetsFactory : public QObject
{
  Q_OBJECT

public:
  /// Instance getter for the singleton class
  /// \return Instance object
  Q_INVOKABLE static qMRMLMarkupsAdditionalOptionsWidgetsFactory* instance();

public:
  /// Registers an additional options widget.
  Q_INVOKABLE bool registerAdditionalOptionsWidget(qMRMLMarkupsAdditionalOptionsWidget* widget);

  /// Unregisters an additional options widget.
  Q_INVOKABLE bool unregisterAdditionalOptionsWidget(qMRMLMarkupsAdditionalOptionsWidget* widget);

  /// Returns the list of additional options widgets registered
  Q_INVOKABLE const QList<QPointer<qMRMLMarkupsAdditionalOptionsWidget>>& additionalOptionsWidgets()
  { return this->AdditionalOptionsWidgets; }

signals:
  void additionalOptionsWidgetRegistered();
  void additionalOptionsWidgetUnregistered();

protected:
  QList<QPointer<qMRMLMarkupsAdditionalOptionsWidget>> AdditionalOptionsWidgets;

private:
  /// Allows cleanup of the singleton at application exit
  static void cleanup();

private:
  qMRMLMarkupsAdditionalOptionsWidgetsFactory(QObject* parent=nullptr);
  ~qMRMLMarkupsAdditionalOptionsWidgetsFactory() override;

  Q_DISABLE_COPY(qMRMLMarkupsAdditionalOptionsWidgetsFactory);
  friend class qMRMLMarkupsAdditionalOptionsWidgetsFactoryCleanup;
  friend class PythonQtWrapper_qMRMLMarkupsAdditionalOptionsWidgetsFactory; // Allow Python wrapping without enabling direct instantiation

private:
  /// Instance of the singleton
  static qMRMLMarkupsAdditionalOptionsWidgetsFactory* Instance;
};

#endif // __qslicermarkupsfactory_h_
