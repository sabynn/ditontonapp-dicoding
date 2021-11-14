import 'dart:convert';
import 'dart:io';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tvseries_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tv_series/tvseries_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Airing Today TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series/airing_today.json')))
        .tvSeriesList;

    test('should return list of TV Series Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/airing_today.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getAiringTodayTvSeries();
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getAiringTodayTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series/tvseries_popular.json')))
        .tvSeriesList;

    test('should return list of tv series when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/tvseries_popular.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getPopularTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series/tvseries_top_rated.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200 ',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/tvseries_top_rated.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series/tvseries_detail.json')));

    test('should return tv series detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series/tvseries_detail.json'), 200));
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tTvSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series recommendations', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(json.decode(
            readJson('dummy_data/tv_series/tvseries_recommendations.json')))
        .tvSeriesList;
    final tId = 1;

    test('should return list of TV Series  Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv_series/tvseries_recommendations.json'),
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },
              ));
      // act
      final result = await dataSource.getTvSeriesRecommendations(tId);
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series/search_tvseries.json')))
        .tvSeriesList;
    final tQuery = "Game of Thrones";

    test('should return list of tv series when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series/search_tvseries.json'), 200));
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
