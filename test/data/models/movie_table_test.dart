import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final movieTable = MovieTable(
    id: 1,
    title: "title",
    posterPath: "/path",
    overview: "overview"
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = movieTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "title": "title",
        "posterPath": "/path",
        "overview": "overview"
      };
      expect(result, expectedJsonMap);
    });
  });
}
