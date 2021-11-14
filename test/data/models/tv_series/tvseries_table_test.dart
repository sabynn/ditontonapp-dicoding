import 'package:ditonton/data/models/tv_series/tvseries_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tvSeriesTable = TvSeriesTable(
      id: 1,
      name: "name",
      posterPath: "/path",
      overview: "overview"
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tvSeriesTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "name",
        "posterPath": "/path",
        "overview": "overview"
      };
      expect(result, expectedJsonMap);
    });
  });
}
