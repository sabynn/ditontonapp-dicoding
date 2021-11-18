part of 'detail_tvseries_bloc.dart';


abstract class DetailTvSeriesEvent extends Equatable {
  const DetailTvSeriesEvent();

  @override
  List<Object?> get props => [];
}

class EventLoadDetailTvSeries extends DetailTvSeriesEvent {
  final int id;

  EventLoadDetailTvSeries({required this.id});
}

class EventAddWatchlist extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  EventAddWatchlist({
    required this.tvSeries,
  });
}

class EventRemoveWatchlist extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeries;

  EventRemoveWatchlist({
    required this.tvSeries,
  });
}

class EventLoadWatchlistStatus extends DetailTvSeriesEvent {
  final int id;

  EventLoadWatchlistStatus({
    required this.id,
  });
}