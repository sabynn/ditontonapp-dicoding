import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tvseries.dart';
import 'package:ditonton/presentation/bloc/watchlist_tvseries/watchlist_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tvseries_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(getWatchlistTvSeries: mockGetWatchlistTvSeries);
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistTvSeriesInitial, StateWatchlistTvSeriesLoaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistTvSeries]));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesInitial(),
        StateWatchlistTvSeriesLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      "should emit [WatchlistTvSeriesInitial, StateLoadWatchlistTvSeriesFailure] when get data is unsuccessful",
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesInitial(),
        StateLoadWatchlistTvSeriesFailure(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      });
}