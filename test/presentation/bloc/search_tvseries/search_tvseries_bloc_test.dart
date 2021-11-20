import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tvseries.dart';
import 'package:ditonton/presentation/bloc/search_tvseries/search_tvseries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'search_tvseries_bloc_test.mocks.dart';


@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc bloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    bloc = SearchTvSeriesBloc(mockSearchTvSeries);
  });

  test('initial state should be empty', () {
    expect(bloc.state, SearchEmpty());
  });

  final tTvSeriesModel = TvSeries(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    idGenre: [1,2,3],
    id : 1,
    name: "name",
    originalCountry: ["originalCountry"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  final tQuery = 'Game of Thrones';

  blocTest<SearchTvSeriesBloc, SearchState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(tTvSeriesList),
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      });

  blocTest<SearchTvSeriesBloc, SearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchError('Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      });
}