import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  String? _message = '';
  String? get message => _message;

  TopRatedMovieBloc({
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getTopRatedMovies = getTopRatedMovies,
        super(TopRatedMovieInitial()) {
    on<EventLoadTopRatedMovie>(_loadTopRatedMovie);
  }

  void _loadTopRatedMovie(
    EventLoadTopRatedMovie event,
    Emitter<TopRatedMovieState> emit,
  ) async {
    emit(TopRatedMovieInitial());
    final result = await _getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(
          StateLoadTopRatedMovieFailure(
            message: failure.message,
          ),
        );
      },
      (data) {
        _movies = data;
        emit(StateTopRatedMovieLoaded());
      },
    );
  }
}
