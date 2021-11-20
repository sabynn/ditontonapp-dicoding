import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tvseries.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvseries_event.dart';
part 'top_rated_tvseries_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;
  List<TvSeries> _tvSeries = [];

  List<TvSeries> get tvSeries => _tvSeries;

  String? _message = '';
  String? get message => _message;

  TopRatedTvSeriesBloc({
    required GetTopRatedTvSeries getTopRatedTvSeries,
  })  : _getTopRatedTvSeries = getTopRatedTvSeries,
        super(TopRatedTvSeriesInitial()) {
    on<EventLoadTopRatedTvSeries>(_loadTopRatedTvSeries);
  }

  void _loadTopRatedTvSeries(
    EventLoadTopRatedTvSeries event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(TopRatedTvSeriesInitial());
    final result = await _getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(
          StateLoadTopRatedTvSeriesFailure(
            message: failure.message,
          ),
        );
      },
      (data) {
        _tvSeries = data;
        emit(StateTopRatedTvSeriesLoaded());
      },
    );
  }
}
