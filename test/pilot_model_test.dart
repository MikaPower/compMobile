import 'package:cmobile/src/models/pilot_model.dart';
import 'package:flutter_test/flutter_test.dart';

class PilotModelTester {
  Pilot pilot;

  void createPilot() {
    pilot = new Pilot.normal("Nuno", "Husqvarna", 300, raceId: 1);
  }
}

void main() {
  group('Counter', () {
    test('Pilot should be created', () {
      final pilotTester = PilotModelTester();
      pilotTester.createPilot();

      expect(pilotTester.pilot.name, "Nuno");
      expect(pilotTester.pilot.bikeName, "Husqvarna");
      expect(pilotTester.pilot.engineSize, 300);
    });

    test('Pilot should created and fail', () {
      final pilotTester = PilotModelTester();
      pilotTester.createPilot();

      expect(pilotTester.pilot.name, "Nuno");
      expect(pilotTester.pilot.bikeName, "Husqvarna");
      expect(pilotTester.pilot.engineSize, "300");
    });
  });
}
