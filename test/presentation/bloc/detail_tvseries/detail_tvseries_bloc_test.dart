import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/detail_tvseries/detail_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'detail_tvseries_bloc_test.mocks.dart';


@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main(){
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
      mockGetTvSeriesDetail = MockGetTvSeriesDetail();
      mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
      mockGetWatchlistStatus = MockGetWatchListStatusTvSeries();
      mockSaveWatchlist = MockSaveWatchlistTvSeries();
      mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
      bloc = TvSeriesDetailBloc(
        getTvSeriesDetail: mockGetTvSeriesDetail,
        getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
        getWatchListStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );
    },
  );

  final tId = 1;

  final tTvSeries = TvSeries(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    idGenre: [1,2,3],
    id : 1,
    name: "name",
    originalCountry: ["originalCountry"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tvSeries = <TvSeries>[tTvSeries];

  group('Get TvSeries Detail', () {
    test(
      'initial state should be empty',
          () {
        expect(bloc.state, StateTvSeriesDetailInitial());
      },
    );

    test(
      'check return of props',
        (){
          List<Object?> expectedId = [tId];
          expect(EventLoadDetailTvSeries(id: tId).props, expectedId);
          List<Object?> expectedTvSeries = [testTvSeriesDetail];
          expect(EventAddWatchlist(tvSeries: testTvSeriesDetail).props, expectedTvSeries);
          expect(EventRemoveWatchlist(tvSeries: testTvSeriesDetail).props, expectedTvSeries);
        },
    );

    blocTest<TvSeriesDetailBloc, DetailTvSeriesState>(
      'Should emit [StateTvSeriesDetailInitial, StateTvSeriesDetailLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tvSeries));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadDetailTvSeries(id: tId)),
      expect: () => [
        StateTvSeriesDetailInitial(),
        StateTvSeriesDetailLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, DetailTvSeriesState>(
      "should emit [StateTvSeriesDetailInitial, StateLoadDetailTvSeriesFailure] when data TvSeries detail is gotten unsuccessfully",
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tvSeries));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadDetailTvSeries(id: tId)),
      expect: () => [
        StateTvSeriesDetailInitial(),
        StateDetailTvSeriesFailure("Failure"),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, DetailTvSeriesState>(
      "should emit [StateTvSeriesDetailLoading, StateWatchlistSuccess] when data is added to wishlist",
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right("Added to Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc.add(EventAddWatchlist(tvSeries: testTvSeriesDetail)),
      expect: () => [
        StateTvSeriesDetailLoading(),
        StateWatchlistTvSeriesSuccess("Added to Watchlist"),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testTvSeriesDetail));
      },
    );

    blocTest<TvSeriesDetailBloc, DetailTvSeriesState>(
      "should emit [StateTvSeriesDetailLoading, StateWatchlistSuccess] when data is removed from wishlist",
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right("Removed from Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc.add(EventRemoveWatchlist(tvSeries: testTvSeriesDetail)),
      expect: () => [
        StateTvSeriesDetailLoading(),
        StateWatchlistTvSeriesSuccess("Removed from Watchlist"),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testTvSeriesDetail));
      },
    );
  });

  blocTest<TvSeriesDetailBloc, DetailTvSeriesState>(
    "should emit [StateTvSeriesDetailLoading, StateWatchlistTvSeriesFailure] when failed add to watchlist",
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
      return bloc;
    },
    act: (bloc) => bloc.add(EventAddWatchlist(tvSeries: testTvSeriesDetail)),
    expect: () => [
      StateTvSeriesDetailLoading(),
      StateWatchlistTvSeriesFailure("Failure"),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testTvSeriesDetail));
    },
  );
}