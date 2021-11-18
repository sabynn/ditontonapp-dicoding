part of 'detail_movie_bloc.dart';

abstract class DetailMovieState extends Equatable {
  const DetailMovieState();

  @override
  List<Object> get props => [];
}
class StateMovieDetailInitial extends DetailMovieState {}

class StateMovieDetailLoading extends DetailMovieState {}

class StateMovieDetailLoaded extends DetailMovieState {}

class StateDetailMoviesFailure extends DetailMovieState {
  final String message;

  const StateDetailMoviesFailure(this.message);

  @override
  List<Object> get props => [message];
}

class StateDetailMoviesSuccess extends DetailMovieState {
  final String message;

  const StateDetailMoviesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class StateCheckWatchlistStatus extends DetailMovieState {
  final bool isAdded;

  StateCheckWatchlistStatus(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}