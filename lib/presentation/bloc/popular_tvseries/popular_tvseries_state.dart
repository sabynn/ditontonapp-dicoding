part of 'popular_tvseries_bloc.dart';

abstract class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();

  @override
  List<Object> get props => [];
}

class PopularTvSeriesInitial extends PopularTvSeriesState {}

class StatePopularTvSeriesLoaded extends PopularTvSeriesState {}

class StateLoadPopularTvSeriesFailure extends PopularTvSeriesState {
  final String message;

  StateLoadPopularTvSeriesFailure({
    this.message = "",
  });

  @override
  List<Object> get props => [message];
}