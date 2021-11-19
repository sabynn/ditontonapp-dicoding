import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tvseries.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvseries_event.dart';
part 'popular_tvseries_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries _getPopularTvSeries;

  List<TvSeries> _tvSeries = [];
  List<TvSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  PopularTvSeriesBloc({
    required GetPopularTvSeries getPopularTvSeries,
  })  : _getPopularTvSeries = getPopularTvSeries,
        super(PopularTvSeriesInitial()) {
    on<EventLoadPopularTvSeries>(_loadPopularTvSeries);
  }

  void _loadPopularTvSeries(
    EventLoadPopularTvSeries event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(PopularTvSeriesInitial());
    final result = await _getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        emit(
          StateLoadPopularTvSeriesFailure(
            message: failure.message,
          ),
        );
      },
      (data) {
        _tvSeries = data;
        emit(StatePopularTvSeriesLoaded());
      },
    );
  }
}
