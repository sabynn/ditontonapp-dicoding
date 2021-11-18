import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
part 'list_movie_event.dart';
part 'list_movie_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;
  
  var _nowPlayingMovies = <Movie>[];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  var _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  String _message = '';
  String get message => _message;

  MovieListBloc({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        super(StateMovieListInitial()) {
    on<EventLoadMovieList>(_fetchMovieList);
  }


  void _fetchMovieList(
      EventLoadMovieList event,
      Emitter<MovieListState> emit,
      ) async {
    emit(StateMovieListInitial());
    final nowPlayingResult = await _getNowPlayingMovies.execute();
    final popularResult = await _getPopularMovies.execute();
    final topRatedResult = await _getTopRatedMovies.execute();
    bool next = true;
    String errorMessage = "";
    nowPlayingResult.fold((failure) {
      errorMessage = failure.message;
    }, (movie) {
      next = next && true;
      _nowPlayingMovies = movie;
    });

    if (next) {
      popularResult.fold((failure) {
        errorMessage = failure.message;
      }, (movie) {
        next = next && true;
        _popularMovies = movie;
      });
    }

    if (next) {
      topRatedResult.fold((failure) {
        errorMessage = failure.message;
      }, (movie) {
        next = next && true;
        _topRatedMovies = movie;
      });
    }

    if (next) {
      emit(StateMovieListLoaded());
    } else {
      emit(StateLoadMovieListFailure(
        message: errorMessage,
      ));
    }
  }
}