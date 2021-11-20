import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tvseries_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tvseries.dart';
import 'package:equatable/equatable.dart';

part 'detail_tvseries_event.dart';
part 'detail_tvseries_state.dart';

class TvSeriesDetailBloc extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail _getTvSeriesDetail;
  final GetTvSeriesRecommendations _getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries _getWatchListStatus;
  final SaveWatchlistTvSeries _saveWatchlist;
  final RemoveWatchlistTvSeries _removeWatchlist;

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;
  
  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  TvSeriesDetailBloc({
    required GetTvSeriesDetail getTvSeriesDetail,
    required GetTvSeriesRecommendations getTvSeriesRecommendations,
    required GetWatchListStatusTvSeries getWatchListStatus,
    required SaveWatchlistTvSeries saveWatchlist,
    required RemoveWatchlistTvSeries removeWatchlist,
  })  : _getTvSeriesDetail = getTvSeriesDetail,
        _getTvSeriesRecommendations = getTvSeriesRecommendations,
        _getWatchListStatus = getWatchListStatus,
        _saveWatchlist = saveWatchlist,
        _removeWatchlist = removeWatchlist,
        super(StateTvSeriesDetailInitial()) {
    on<EventLoadDetailTvSeries>(_fetchTvSeriesDetail);
    on<EventAddWatchlist>(_addWatchlist);
    on<EventRemoveWatchlist>(_removeFromWatchlist);
  }

  void _fetchTvSeriesDetail(
      EventLoadDetailTvSeries event,
      Emitter<DetailTvSeriesState> emit,
      ) async {
    emit(StateTvSeriesDetailInitial());
    final detailResult = await _getTvSeriesDetail.execute(event.id);
    final recommendationResult =
    await _getTvSeriesRecommendations.execute(event.id);
    final statusResult = await _getWatchListStatus.execute(event.id);
    _isAddedToWatchlist = statusResult;
    detailResult.fold(
          (failure) {
        emit(StateDetailTvSeriesFailure(failure.message));
      },
          (tvSerie) {
        _tvSeries = tvSerie;
        recommendationResult.fold(
              (failure) {
            emit(StateDetailTvSeriesFailure(failure.message));
          },
              (tvSeries) {
            _tvSeriesRecommendations = tvSeries;
          },
        );
        emit(StateTvSeriesDetailLoaded());
      },
    );
  }

  void _addWatchlist(
      EventAddWatchlist event,
      Emitter<DetailTvSeriesState> emit,
      ) async {
    emit(StateTvSeriesDetailLoading());
    final result = await _saveWatchlist.execute(event.tvSeries);

    await result.fold(
          (failure) async {
        emit(StateWatchlistTvSeriesFailure(failure.message));
      },
          (successMessage) async {
        _isAddedToWatchlist = true;
        emit(StateWatchlistTvSeriesSuccess(successMessage));
      },
    );
  }

  void _removeFromWatchlist(
      EventRemoveWatchlist event,
      Emitter<DetailTvSeriesState> emit,
      ) async {
    emit(StateTvSeriesDetailLoading());
    final result = await _removeWatchlist.execute(event.tvSeries);

    await result.fold(
          (failure) async {
        emit(StateWatchlistTvSeriesFailure(failure.message));
      },
          (successMessage) async {
        _isAddedToWatchlist = false;
        emit(StateWatchlistTvSeriesSuccess(successMessage));
      },
    );
  }
}
