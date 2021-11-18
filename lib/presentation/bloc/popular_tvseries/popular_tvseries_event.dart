part of 'popular_tvseries_bloc.dart';

abstract class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();

  @override
  List<Object> get props => [];
}
class EventLoadPopularTvSeries extends PopularTvSeriesEvent {}