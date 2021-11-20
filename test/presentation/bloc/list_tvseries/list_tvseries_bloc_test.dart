import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_airing_today_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/bloc/list_tvseries/list_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'list_tvseries_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main(){
  late TvSeriesListBloc bloc;
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TvSeriesListBloc(
      getAiringTodayTvSeries: mockGetAiringTodayTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  group('now playing TvSeries', () {
    test('initialState should be Empty', () {
      expect(bloc.state, StateTvSeriesListInitial());
    });

    test(
      'check return of props',
          (){
        List<Object?> expectedProp = [];
        expect(EventLoadTvSeriesList().props, expectedProp);
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
        'should emit [StateTvSeriesListInitial, StateTvSeriesListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetAiringTodayTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          return bloc;
        },
        act: (bloc) => bloc.add(EventLoadTvSeriesList()),
        expect: () => [
          StateTvSeriesListInitial(),
          StateTvSeriesListLoaded(),
        ],
        verify: (bloc) {
          verify(mockGetAiringTodayTvSeries.execute());
          verify(mockGetPopularTvSeries.execute());
          verify(mockGetTopRatedTvSeries.execute());
        });

    blocTest<TvSeriesListBloc, TvSeriesListState>(
        "should emit [StateTvSeriesListInitial, StateLoadTvSeriesListFailure] when get data is unsuccessful",
        build: () {
          when(mockGetAiringTodayTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(testTvSeriesList));
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failure')));
          return bloc;
        },
        act: (bloc) => bloc.add(EventLoadTvSeriesList()),
        expect: () => [
          StateTvSeriesListInitial(),
          StateLoadTvSeriesListFailure(message: 'Failure'),
        ],
        verify: (bloc) {
          verify(mockGetAiringTodayTvSeries.execute());
          verify(mockGetPopularTvSeries.execute());
          verify(mockGetTopRatedTvSeries.execute());
        });
  });
}