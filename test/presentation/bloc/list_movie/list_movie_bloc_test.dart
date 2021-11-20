import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/list_movie/list_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'list_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  group('now playing movies', () {
    test('initialState should be Empty', () {
      expect(bloc.state, StateMovieListInitial());
    });

    test(
      'check return of props',
          (){
        List<Object?> expectedProp = [];
        expect(EventLoadMovieList().props, expectedProp);
      },
    );

    blocTest<MovieListBloc, MovieListState>(
        'should emit [StateMovieListInitial, StateMovieListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          return bloc;
        },
        act: (bloc) => bloc.add(EventLoadMovieList()),
        expect: () => [
          StateMovieListInitial(),
          StateMovieListLoaded(),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
          verify(mockGetPopularMovies.execute());
          verify(mockGetTopRatedMovies.execute());
        });

    blocTest<MovieListBloc, MovieListState>(
        "should emit [StateMovieListInitial, StateLoadMovieListFailure] when get data is unsuccessful",
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failure')));
          return bloc;
        },
        act: (bloc) => bloc.add(EventLoadMovieList()),
        expect: () => [
          StateMovieListInitial(),
          StateLoadMovieListFailure(message: 'Failure'),
        ],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
          verify(mockGetPopularMovies.execute());
          verify(mockGetTopRatedMovies.execute());
        });
  });
}