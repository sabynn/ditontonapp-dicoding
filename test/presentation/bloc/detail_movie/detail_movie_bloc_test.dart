import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/detail_movie/detail_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(
    () {
      mockGetMovieDetail = MockGetMovieDetail();
      mockGetMovieRecommendations = MockGetMovieRecommendations();
      mockGetWatchlistStatus = MockGetWatchListStatus();
      mockSaveWatchlist = MockSaveWatchlist();
      mockRemoveWatchlist = MockRemoveWatchlist();
      bloc = MovieDetailBloc(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations,
        getWatchListStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );
    },
  );

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    test(
      'initial state should be empty',
      () {
        expect(bloc.state, StateMovieDetailInitial());
      },
    );

    test(
      'check return of props',
          (){
        List<Object?> expectedId = [tId];
        expect(EventLoadDetailMovie(id: tId).props, expectedId);
        List<Object?> expectedMovie = [testMovieDetail];
        expect(EventAddWatchlist(movie: testMovieDetail).props, expectedMovie);
        expect(EventRemoveWatchlist(movie: testMovieDetail).props, expectedMovie);
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      'Should emit [StateMovieDetailInitial, StateMovieDetailLoaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadDetailMovie(id: tId)),
      expect: () => [
        StateMovieDetailInitial(),
        StateMovieDetailLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      "should emit [StateMovieDetailInitial, StateLoadDetailMovieFailure] when data movie detail is gotten unsuccessfully",
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadDetailMovie(id: tId)),
      expect: () => [
        StateMovieDetailInitial(),
        StateLoadDetailMovieFailure(message: "Failure"),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      "should emit [StateMovieDetailLoading, StateWatchlistSuccess] when data is added to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right("Added to Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc.add(EventAddWatchlist(movie: testMovieDetail)),
      expect: () => [
        StateMovieDetailLoading(),
        StateWatchlistSuccess("Added to Watchlist"),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      "should emit [StateMovieDetailLoading, StateWatchlistFailure] when failed add to watchlist",
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(EventAddWatchlist(movie: testMovieDetail)),
      expect: () => [
        StateMovieDetailLoading(),
        StateWatchlistFailure("Failure"),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      "should emit [StateMovieDetailLoading, StateWatchlistSuccess] when data is removed from watchlist",
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right("Removed from Watchlist"));
        return bloc;
      },
      act: (bloc) => bloc.add(EventRemoveWatchlist(movie: testMovieDetail)),
      expect: () => [
        StateMovieDetailLoading(),
        StateWatchlistSuccess("Removed from Watchlist"),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
      },
    );
  });

  group('Get Movie Recommendations', () {
    test(
      'initial state should be empty',
      () {
        expect(bloc.state, StateMovieDetailInitial());
        expect(EventLoadDetailMovie(id: tId).id, tId);
      },
    );

    blocTest<MovieDetailBloc, DetailMovieState>(
      "should emit [StateMovieDetailInitial, StateLoadMovieRecommendationFailure"
          ", StateMovieDetailLoaded] when data movie recommendations is gotten unsuccessfully",
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadDetailMovie(id: tId)),
      expect: () => [
        StateMovieDetailInitial(),
        StateLoadMovieRecommendationFailure(
          message: "Failure",
        ),
        StateMovieDetailLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });
}
