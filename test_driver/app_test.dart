// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Register pilot', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final insert_user_screen_form = find.byValueKey('form_user');
    final insert_name_button = find.byValueKey('submit_user');
    final button_text = find.byValueKey('submit_button_text');
    final insert_user_screen_submit_button =
        find.byValueKey('insert_user_screen_submit_user_button');
    /*final buttonFinder = find.byValueKey('increment');*/

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('first screen', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(button_text), "Submit");
    });

    test('Insert username', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(insert_user_screen_form); // acquire focus
      await driver.enterText("Nuno");
      await driver.waitFor(find.text('Nuno'));
      await driver.enterText('Nuno Micael'); // verify text appears on UI
    });

    test('submits username', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(insert_user_screen_submit_button); // acquire focus
    });

/*    test('increments the counter', () async {
      // First, tap the button.
      await driver.tap(buttonFinder);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(counterTextFinder), "1");
    });*/
  });
}
