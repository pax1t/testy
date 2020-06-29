import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  group('Sun App', () {
    FlutterDriver driver;
    final homeFinder = find.text('Home');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Starts at Home', () async {
      expect(await driver.getText(homeFinder), 'Home');
    });

    test('Going to Sun', () async {
      await driver.waitFor(find.byType('RaisedButton'));
      driver.tap(find.byType('RaisedButton'));
      await driver.waitFor(find.text('Sun'));
      await driver.waitFor(find.text('Sunset'));
      /// TODO: Add checking for real sunset data
      expect(await driver.getText(find.text('Sunset')), 'Sunset');
    });

  });
}
