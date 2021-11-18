part of 'list_movie_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object?> get props => [];
}

class EventLoadMovieList extends MovieListEvent {}