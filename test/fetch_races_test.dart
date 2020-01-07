// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
import 'package:cmobile/src/api/requestRacesApi.dart';
import 'package:cmobile/src/models/race_model.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

class MockClient extends Mock implements http.Client {
  RacesApiProvider api = RacesApiProvider();
}

main() {
  group('fetchPost', () {
    test('returns races if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('http://127.0.0.1:8000/races')).thenAnswer((_) async =>
          http.Response(
              '[{"races": [{"id": 3,"name": "sx","latitude": "41.173124 ",'
                  '"longitude": "-8.611110","image": "nothing"},{"id": 1, '
                  '"name": "Extreme", "latitude": "41.173124 ", "longitude": "-8.611110", "image": "nothing"}]}]',
              200));
      expect(
          await client.api.fetchRaces(client), const TypeMatcher<RacesModel>());
    });

    test('throws an exception if the http call completes with an error', () async {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get('http://127.0.0.1:8000/races'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      RacesModel races = await (client.api.fetchRaces(client));
      expect(races, null);
    });
  });
}
