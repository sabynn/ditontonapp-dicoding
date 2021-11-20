part of 'detail_tvseries_bloc.dart';

abstract class DetailTvSeriesEvent extends Equatable {
  const DetailTvSeriesEvent();
}

class EventLoadDetailTvSeries extends DetailTvSeriesEvent {
  final int id;

  EventLoadDetailTvSeries({required this.id});

  List<Object?> get props => [id];
}

class EventAddWatchlist extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  EventAddWatchlist({
    required this.tvSeries,
  });

  List<Object?> get props => [tvSeries];
}

class EventRemoveWatchlist extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  EventRemoveWatchlist({
    required this.tvSeries,
  });

  List<Object?> get props => [tvSeries];
}