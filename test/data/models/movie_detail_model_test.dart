import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    budget: 1,
    genres: [GenreModel(id: 1, name: "Action")],
    homepage: "homepage",
    id: 1,
    imdbId: "imdbId",
    originalLanguage: "Original Language",
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    revenue: 100,
    runtime: 100,
    status: "ended",
    tagline: "tagline",
    title: "Title",
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "budget": 1,
        "genres": [{"id": 1, "name": "Action"}],
        "homepage": "homepage",
        "id": 1,
        "imdb_id": "imdbId",
        "original_language": "Original Language",
        "original_title": "Original Title",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "release_date": "2020-05-05",
        "revenue": 100,
        "runtime": 100,
        "status": "ended",
        "tagline": "tagline",
        "title": "Title",
        "video": false,
        "vote_average": 1.0,
        "vote_count": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
