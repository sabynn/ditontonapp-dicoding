import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series/tvseries_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesDetailResponse = TvSeriesDetailResponse(
    backdropPath: "/path.jpg",
    firstAirDate: "firstAirDate",
    genres: [GenreModel(id: 1, name: "Action")],
    id: 1,
    lastAirDate: "lastAirDate",
    name: "name",
    originalName: "originalName",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    status: "ended",
    tagline: "tagline",
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "backdrop_path": "/path.jpg",
        "first_air_date": "firstAirDate",
        "genres": [
          {"id": 1, "name": "Action"}
        ],
        "id": 1,
        "last_air_date": "lastAirDate",
        "name": "name",
        "original_name": "originalName",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "status": "ended",
        "tagline": "tagline",
        "vote_average": 1.0,
        "vote_count": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
