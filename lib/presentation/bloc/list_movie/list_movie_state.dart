part of 'list_movie_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class StateMovieListInitial extends MovieListState {}

class StateMovieListLoaded extends MovieListState {}

class StateLoadMovieListFailure extends MovieListState {
  final String message;

  StateLoadMovieListFailure({
    this.message = "",
  });
}