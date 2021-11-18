part of 'top_rated_tvseries_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedTvSeriesInitial extends TopRatedTvSeriesState {}

class StateTopRatedTvSeriesLoaded extends TopRatedTvSeriesState {}

class StateLoadTopRatedTvSeriesFailure extends TopRatedTvSeriesState {
  final String message;

  StateLoadTopRatedTvSeriesFailure({
    this.message = "",
  });

  @override
  List<Object?> get props => [message];
}