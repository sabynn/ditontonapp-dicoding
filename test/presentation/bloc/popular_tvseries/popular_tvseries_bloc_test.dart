import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tvseries.dart';
import 'package:ditonton/presentation/bloc/popular_tvseries/popular_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../list_tvseries/list_tvseries_bloc_test.mocks.dart';


@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc bloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(getPopularTvSeries: mockGetPopularTvSeries);
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emit [PopularTvSeriesInitial, PopularTvSeriesLoadedState] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistTvSeries]));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadPopularTvSeries()),
      expect: () => [
        PopularTvSeriesInitial(),
        StatePopularTvSeriesLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      "should emit [PopularTvSeriesInitial, LoadPopularTvSeriesFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadPopularTvSeries()),
      expect: () => [
        PopularTvSeriesInitial(),
        StateLoadPopularTvSeriesFailure(message: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      });
}