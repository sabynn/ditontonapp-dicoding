import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';


@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [WatchlistMovieInitial, StateWatchlistMovieLoaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadWatchlistMovie()),
      expect: () => [
        WatchlistMovieInitial(),
        StateWatchlistMovieLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      "should emit [WatchlistMovieInitial, StateLoadWatchlistMovieFailure] when get data is unsuccessful",
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadWatchlistMovie()),
      expect: () => [
        WatchlistMovieInitial(),
        StateLoadWatchlistMovieFailure(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });
}