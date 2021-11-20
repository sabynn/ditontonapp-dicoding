import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String? _message = '';
  String? get message => _message;

  PopularMovieBloc({
    required GetPopularMovies getPopularMovies,
  })  : _getPopularMovies = getPopularMovies,
        super(PopularMovieInitial()) {
    on<EventLoadPopularMovie>(_loadPopularMovie);
  }

  void _loadPopularMovie(
      EventLoadPopularMovie event,
    Emitter<PopularMovieState> emit,
  ) async {
    emit(PopularMovieInitial());
    final result = await _getPopularMovies.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(
          StateLoadPopularMovieFailure(
            message: failure.message,
          ),
        );
      },
      (data) {
        _movies = data;
        emit(StatePopularMovieLoaded());
      },
    );
  }
}
