part of 'detail_tvseries_bloc.dart';

abstract class DetailTvSeriesState extends Equatable {
  const DetailTvSeriesState();

  @override
  List<Object> get props => [];
}
class StateTvSeriesDetailInitial extends DetailTvSeriesState {}

class StateTvSeriesDetailLoading extends DetailTvSeriesState {}

class StateTvSeriesDetailLoaded extends DetailTvSeriesState {}

class StateDetailTvSeriesFailure extends DetailTvSeriesState {
  final String message;

  const StateDetailTvSeriesFailure(this.message);

  @override
  List<Object> get props => [message];
}

class StateDetailTvSeriesSuccess extends DetailTvSeriesState {
  final String message;

  const StateDetailTvSeriesSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class StateCheckWatchlistStatus extends DetailTvSeriesState {
  final bool isAdded;

  StateCheckWatchlistStatus(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}