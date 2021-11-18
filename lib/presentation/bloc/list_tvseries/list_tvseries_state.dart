part of 'list_tvseries_bloc.dart';

abstract class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  @override
  List<Object> get props => [];
}

class StateTvSeriesListInitial extends TvSeriesListState {}

class StateTvSeriesListLoaded extends TvSeriesListState {}

class StateLoadTvSeriesListFailure extends TvSeriesListState {
  final String message;

  StateLoadTvSeriesListFailure({
    this.message = "",
  });
}