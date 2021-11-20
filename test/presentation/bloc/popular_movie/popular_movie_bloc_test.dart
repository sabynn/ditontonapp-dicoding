import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../list_movie/list_movie_bloc_test.mocks.dart';


@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit [PopularMovieInitial, PopularMovieLoadedState] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadPopularMovie()),
      expect: () => [
        PopularMovieInitial(),
        StatePopularMovieLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });

  blocTest<PopularMovieBloc, PopularMovieState>(
      "should emit [PopularMovieInitial, LoadPopularMovieFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadPopularMovie()),
      expect: () => [
        PopularMovieInitial(),
        StateLoadPopularMovieFailure(message: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      });
}