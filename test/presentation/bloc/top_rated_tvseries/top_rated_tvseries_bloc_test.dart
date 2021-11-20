import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tvseries.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../list_tvseries/list_tvseries_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main(){
  late TopRatedTvSeriesBloc bloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries: mockGetTopRatedTvSeries);
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emit [TopRatedTvSeriesInitial, TopRatedTvSeriesLoadedState] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right([testWatchlistTvSeries]));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesInitial(),
        StateTopRatedTvSeriesLoaded(),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      "should emit [TopRatedTvSeriesInitial, LoadTopRatedTvSeriesFailureState] when get data is unsuccessful",
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(EventLoadTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesInitial(),
        StateLoadTopRatedTvSeriesFailure(message: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      });
}