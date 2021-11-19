import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tvseries.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tvseries_event.dart';
part 'watchlist_tvseries_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries _getWatchlistTvSeries;
  List<TvSeries> _watchlistTvSeries = [];

  List<TvSeries> get tvSeries => _watchlistTvSeries;

  String _message = '';
  String get message => _message;

  WatchlistTvSeriesBloc({
    required GetWatchlistTvSeries getWatchlistTvSeries,
  })  : _getWatchlistTvSeries = getWatchlistTvSeries,
        super(WatchlistTvSeriesInitial()) {
    on<EventLoadWatchlistTvSeries>(_loadWatchlistTvSeries);
  }

  void _loadWatchlistTvSeries(
    EventLoadWatchlistTvSeries event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(WatchlistTvSeriesInitial());
    final result = await _getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(
          StateLoadWatchlistTvSeriesFailure(
            message: failure.message,
          ),
        );
      },
      (data) {
        _watchlistTvSeries = data;
        emit(StateWatchlistTvSeriesLoaded());
      },
    );
  }
}
