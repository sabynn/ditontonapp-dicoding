import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_airing_today_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tvseries.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tvseries.dart';
import 'package:equatable/equatable.dart';

part 'list_tvseries_event.dart';
part 'list_tvseries_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetAiringTodayTvSeries _getNowPlayingTvSeries;
  final GetPopularTvSeries _getPopularTvSeries;
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  var _nowPlayingTvSeries = <TvSeries>[];
  List<TvSeries> get nowPlayingTvSeries => _nowPlayingTvSeries;

  var _popularTvSeries = <TvSeries>[];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  var _topRatedTvSeries = <TvSeries>[];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  String _message = '';
  String get message => _message;

  TvSeriesListBloc({
    required GetAiringTodayTvSeries getNowPlayingTvSeries,
    required GetPopularTvSeries getPopularTvSeries,
    required GetTopRatedTvSeries getTopRatedTvSeries,
  })  : _getNowPlayingTvSeries = getNowPlayingTvSeries,
        _getPopularTvSeries = getPopularTvSeries,
        _getTopRatedTvSeries = getTopRatedTvSeries,
        super(StateTvSeriesListInitial()) {
    on<EventLoadTvSeriesList>(_fetchTvSeriesList);
  }


  void _fetchTvSeriesList(
      EventLoadTvSeriesList event,
      Emitter<TvSeriesListState> emit,
      ) async {
    emit(StateTvSeriesListInitial());
    final nowPlayingResult = await _getNowPlayingTvSeries.execute();
    final popularResult = await _getPopularTvSeries.execute();
    final topRatedResult = await _getTopRatedTvSeries.execute();
    bool next = true;
    String errorMessage = "";
    nowPlayingResult.fold((failure) {
      errorMessage = failure.message;
    }, (tvSeries) {
      next = next && true;
      _nowPlayingTvSeries = tvSeries;
    });

    if (next) {
      popularResult.fold((failure) {
        errorMessage = failure.message;
      }, (tvSeries) {
        next = next && true;
        _popularTvSeries = tvSeries;
      });
    }

    if (next) {
      topRatedResult.fold((failure) {
        errorMessage = failure.message;
      }, (tvSeries) {
        next = next && true;
        _topRatedTvSeries = tvSeries;
      });
    }

    if (next) {
      emit(StateTvSeriesListLoaded());
    } else {
      emit(StateLoadTvSeriesListFailure(
        message: errorMessage,
      ));
    }
  }
}