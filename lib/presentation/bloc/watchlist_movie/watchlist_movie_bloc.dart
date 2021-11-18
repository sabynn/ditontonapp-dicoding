import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  List<Movie> _watchlistMovies = [];

  List<Movie> get watchlistMovies => _watchlistMovies;

  WatchlistMovieBloc({
    required GetWatchlistMovies getWatchlistMovies,
  })  : _getWatchlistMovies = getWatchlistMovies,
        super(WatchlistMovieInitial()) {
    on<EventLoadWatchlistMovie>(_loadWatchlistMovie);
  }

  void _loadWatchlistMovie(
    EventLoadWatchlistMovie event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(WatchlistMovieInitial());
    final result = await _getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(StateLoadWatchlistMovieFailure(
        message: failure.message,
      )),
      (data) {
        _watchlistMovies = data;
        emit(StateWatchlistMovieLoaded());
      },
    );
  }
}
