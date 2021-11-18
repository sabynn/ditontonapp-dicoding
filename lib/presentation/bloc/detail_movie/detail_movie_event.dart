part of 'detail_movie_bloc.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object?> get props => [];
}

class EventLoadDetailMovie extends DetailMovieEvent {
  final int id;

  EventLoadDetailMovie({required this.id});
}

class EventAddWatchlist extends DetailMovieEvent {
  final MovieDetail movie;

  EventAddWatchlist({
    required this.movie,
  });
}

class EventRemoveWatchlist extends DetailMovieEvent {
  final MovieDetail movie;

  EventRemoveWatchlist({
    required this.movie,
  });
}

class EventLoadWatchlistStatus extends DetailMovieEvent {
  final int id;

  EventLoadWatchlistStatus({
    required this.id,
  });
}
