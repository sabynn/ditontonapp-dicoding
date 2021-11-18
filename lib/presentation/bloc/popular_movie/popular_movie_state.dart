part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class StatePopularMovieLoaded extends PopularMovieState {}

class StateLoadPopularMovieFailure extends PopularMovieState {
  final String message;

  StateLoadPopularMovieFailure({
    this.message = "",
  });

  @override
  List<Object> get props => [message];
}