part of 'list_tvseries_bloc.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object?> get props => [];
}

class EventLoadTvSeriesList extends TvSeriesListEvent {}