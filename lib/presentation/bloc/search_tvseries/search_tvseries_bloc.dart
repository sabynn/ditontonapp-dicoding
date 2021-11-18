import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tvseries.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

part 'search_tvseries_event.dart';
part 'search_tvseries_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchTvSeries _searchTvSeries;

  SearchBloc(this._searchTvSeries) : super(SearchEmpty());

  @override
  Stream<SearchState> mapEventToState(
      SearchEvent event,
      ) async* {
    if (event is OnQueryChanged) {
      final query = event.query;

      yield SearchLoading();
      final result = await _searchTvSeries.execute(query);

      yield* result.fold(
            (failure) async* {
          yield SearchError(failure.message);
        },
            (data) async* {
          yield SearchHasData(data);
        },
      );
    }
  }


  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .flatMap(transitionFn);
  }
}
