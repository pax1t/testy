// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';

import 'package:testy/main.dart';
import 'package:testy/models/models.dart';
import 'package:testy/pages/pages.dart';
import 'package:testy/pages/speed_dial.dart';

import 'package:testy/repositories/repositories.dart';

class MockSunRepository extends Mock implements SunDataRepository {}
class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Test CounterTitle widget', (WidgetTester tester) async {
    final key = Key('k');
    final title = 'Counter';
    final message = 'Start';

    await tester.pumpWidget(CounterTitle(key: key, title: title, message: message));

    // Finders
    final keyFinder = find.byKey(key);
    final titleFinder = find.text(title);
    final messageFinder = find.text(message);

    expect(keyFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });

  testWidgets('Test CounterTitle as child', (WidgetTester tester) async {
    final childWidget = CounterTitle(title: 'Counter', message: 'Start');

    await tester.pumpWidget(Center(child: childWidget));
    expect(find.byWidget(childWidget), findsOneWidget);
  });

  testWidgets('Add and remove SpeedDial', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SpeedDialList()));

    await tester.enterText(find.byType(TextField), 'Query');

    await tester.tap(find.byIcon(Icons.save));

    await tester.pump();

    final findSpeedDial = find.text('Query');

    expect(findSpeedDial, findsOneWidget);
    
    await tester.drag(findSpeedDial, Offset(500.0, 0.0));

    await tester.pumpAndSettle();

    expect(find.text('Query'), findsNothing);
  });

  testWidgets('Tapping Sunny button on HomePage opens SunPage', (WidgetTester tester) async {
    final sunRepo = MockSunRepository();
    final locationRepo = MockLocationRepository();
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (context) => HomePage(),
          '/sun': (context) => SunPage(
            sunRepo: sunRepo,
            locationRepo: locationRepo,
          ),
        },
        initialRoute: '/',
      ),
    );

    // inject SunData and LocationData for FutureBuilder
    when(locationRepo.getLocation())
        .thenAnswer((_) async =>
        LocationData.fromMap({
          'latitude': 50.0,
          'longitude': 50.0,
        }));
    when(sunRepo.byLocation(50.0, 50.0)).thenAnswer((_) async => SunData(
      dayLength: 10,
      sunrise: DateTime.now(),
      sunset: DateTime.now(),
    ));

    await tester.tap(find.byIcon(Icons.wb_sunny));
    await tester.pumpAndSettle();
    expect(find.text('Sun'), findsOneWidget);
  });

  testWidgets('Going to SunPage the data is displayed', (WidgetTester tester) async {
    final sunRepo = MockSunRepository();
    final locationRepo = MockLocationRepository();
    // Mocking Sun data
    final mockSunData = SunData(
      sunrise: DateTime.now(),
      sunset: DateTime.now().add(Duration(hours: 6)),
      dayLength: Duration(hours: 6).inSeconds,
    );
    when(locationRepo.getLocation()).thenAnswer((_) async => LocationData.fromMap({
      'latitude': 50.0,
      'longitude': 50.0,
    }));
    when(sunRepo.byLocation(50.0, 50.0)).thenAnswer((_) async => mockSunData);

    await tester.pumpWidget(
      MaterialApp(
        home: SunPage(
          sunRepo: sunRepo,
          locationRepo: locationRepo,
        ),
      ),
    );
    expect(find.text('Sun'), findsOneWidget);
  });

}
