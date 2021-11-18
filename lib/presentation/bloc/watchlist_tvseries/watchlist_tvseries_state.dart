part of 'watchlist_tvseries_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

class StateWatchlistTvSeriesLoaded extends WatchlistTvSeriesState {}

class StateLoadWatchlistTvSeriesFailure extends WatchlistTvSeriesState {
  final String message;

  StateLoadWatchlistTvSeriesFailure({
    this.message = "",
  });
}