import 'dart:convert';


import 'package:ditonton/data/models/tv_series/tvseries_model.dart';
import 'package:ditonton/data/models/tv_series/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/b0BckgEovxYLBbIk5xXyWYQpmlT.jpg",
    firstAirDate: "2016-08-28",
    idGenre: null,
    id: 67419,
    name: "Victoria",
    originalCountry: ["GB"],
    originalLanguage: "en",
    originalName: "Victoria",
    overview: "The early life of Queen Victoria, from her accession to the throne at the tender age of 18 through to her courtship and marriage to Prince Albert. Victoria went on to rule for 63 years, and was the longest-serving monarch until she was overtaken by Elizabeth II on 9th September 2016. Rufus Sewell was Victoria’s first prime minister; the two immediately connected and their intimate friendship became a popular source of gossip that threatened to destabilise the Government – angering both Tory and Whigs alike.",
    popularity: 11.520271,
    posterPath: "/zra8NrzxaEeunRWJmUm3HZOL4sd.jpg",
    voteAverage:  1.39,
    voteCount: 9,
  );
  final tTvSeriesResponseModel =
  TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/tv_series/airing_today.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/b0BckgEovxYLBbIk5xXyWYQpmlT.jpg",
            "first_air_date": "2016-08-28",
            "genre_ids": null,
            "id": 67419,
            "name": "Victoria",
            "origin_country": ["GB"],
            "original_language": "en",
            "original_name": "Victoria",
            "overview":"The early life of Queen Victoria, from her accession to the throne at the tender age of 18 through to her courtship and marriage to Prince Albert. Victoria went on to rule for 63 years, and was the longest-serving monarch until she was overtaken by Elizabeth II on 9th September 2016. Rufus Sewell was Victoria’s first prime minister; the two immediately connected and their intimate friendship became a popular source of gossip that threatened to destabilise the Government – angering both Tory and Whigs alike.",
            "popularity": 11.520271,
            "poster_path": "/zra8NrzxaEeunRWJmUm3HZOL4sd.jpg",
            "vote_average": 1.39,
            "vote_count": 9,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
