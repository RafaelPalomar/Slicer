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

// This tests the markups additional options wigets factory.

// Markups widgets includes
#include "qMRMLMarkupsAdditionalOptionsWidgetsFactory.h"
#include "qMRMLMarkupsAdditionalCurveSettingsOptionsWidget.h"
#include "qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget.h"

// Markups tests includes
#include "qMRMLMarkupsAdditionalMalformedOptionsWidget.h"

// CTK includes
#include "ctkTest.h"

// Qt includes
#include <QScopedPointer>
#include <QSignalSpy>
#include <QTest>

//------------------------------------------------------------------------------
class qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester : public QObject
{
  Q_OBJECT

  private slots:

    // Test registration of a valid additional widget without making use of it
    void testAdditionalOptionsWidgetRegistration1();

    // Test registration of a nullptr
    void testAdditionalOptionsWidgetRegistration2();

    // Test registration of a malformed widget
    void testAdditionalOptionsWidgetRegistration3();

    // Test registration of a valid additional wiget and unregister malformed
    // widget
    void testAdditionalOptionsWidgetRegistration4();

    // Test registration of a valid additional wiget and unregister another type
    // of widget
    void testAdditionalOptionsWidgetRegistration5();

    // Test registration of a valid additional wiget making use of it.
    // Deallocation is performed by widget going out of scope
    void testAdditionalOptionsWidgetRegistration6();

    // NOTE: This test should be the last one! Test registration of a valid
    // additional wiget. Deallocation happens by termination of factory.
    void testAdditionalOptionsWidgetRegistration7();
};


//------------------------------------------------------------------------------
// In this test we register a valid optional widget
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration1()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));

  // Test registration of a valid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget());
  QCOMPARE(registeredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);

  // Test unregistration of a valid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget());
  QCOMPARE(unregisteredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a nullptr widget and try to unregister
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration2()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));

  // Test registration of a valid widget
  factory->registerAdditionalOptionsWidget(nullptr);
  QCOMPARE(registeredSignalSpy.count(), 0); // Make sure the signal does not trigger
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);

  // Test unregistration of a valid widget
  factory->unregisterAdditionalOptionsWidget(nullptr);
  QCOMPARE(unregisteredSignalSpy.count(), 0); // Make sure the signal does not trigger
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a malformed widget
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration3()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));

  // Test registration of an invalid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalMalformedOptionsWidget);
  QCOMPARE(registeredSignalSpy.count(), 0); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);

  // Test unregistration of an invalid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalMalformedOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 0); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a valid widget and try to unregister a malformed one
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration4()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));

  // Test registration of an invalid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(registeredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);

  // Test unregistration of an invalid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalMalformedOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 0); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);

  // Test unregistration of a valid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a valid widget and try to unregister a valid different type
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration5()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));

  // Test registration of an invalid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(registeredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);

  // Test unregistration of an invalid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalAngleMeasurementsOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 0); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);

  // Test unregistration of a valid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a valid widget and make use of it
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration6()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));
  QSignalSpy unregisteredSignalSpy(factory, SIGNAL(additionalOptionsWidgetUnregistered()));
  QScopedPointer<QWidget> widgetPtr(new QWidget);

  // Test registration of an invalid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(registeredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);
  registeredWidgets[0]->setParent(widgetPtr.data());

  // Test unregistration of a valid widget
  factory->unregisterAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(unregisteredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 0);
}

//------------------------------------------------------------------------------
// In this test we register a valid widget and make use of it
void qMRMLMarkupsAdditionalOptionsWidgetsFactoryTester::
testAdditionalOptionsWidgetRegistration7()
{
  auto factory = qMRMLMarkupsAdditionalOptionsWidgetsFactory::instance();
  QSignalSpy registeredSignalSpy(factory, SIGNAL(additionalOptionsWidgetRegistered()));

  // Test registration of an invalid widget
  factory->registerAdditionalOptionsWidget(new qMRMLMarkupsAdditionalCurveSettingsOptionsWidget);
  QCOMPARE(registeredSignalSpy.count(), 1); // Make sure the signal triggers only 1 time.
  auto registeredWidgets = factory->additionalOptionsWidgets();
  QVERIFY(registeredWidgets.length() == 1);
}

//------------------------------------------------------------------------------
CTK_TEST_MAIN(qMRMLMarkupsAdditionalOptionsWidgetsFactoryTest)
#include "moc_qMRMLMarkupsAdditionalOptionsWidgetsFactoryTest.cxx"
