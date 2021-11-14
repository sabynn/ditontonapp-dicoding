import 'dart:convert';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series/tvseries_detail_model.dart';
import 'package:ditonton/data/models/tv_series/tvseries_model.dart';
import 'package:ditonton/data/models/tv_series/tvseries_response.dart';
import 'package:http/http.dart' as http;

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getAiringTodayTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getAiringTodayTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
