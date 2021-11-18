part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}

class StateTopRatedMovieLoaded extends TopRatedMovieState {}

class StateLoadTopRatedMovieFailure extends TopRatedMovieState {
  final String message;

  StateLoadTopRatedMovieFailure({
    this.message = "",
  });

  @override
  List<Object?> get props => [message];
}