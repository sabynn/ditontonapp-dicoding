import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/detail_tvseries/detail_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tvseries_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class FakeDetailEvent extends Fake implements DetailTvSeriesEvent {}

class FakeDetailState extends Fake implements DetailTvSeriesState {}

class MockTvSeriesDetailBloc extends MockBloc<DetailTvSeriesEvent, DetailTvSeriesState>
    implements TvSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;
  int tId = 1;

  setUpAll(() {
    registerFallbackValue(FakeDetailEvent());
    registerFallbackValue(FakeDetailState());
  });

  setUp(() async {
    await GetIt.I.reset();
    await di.init();
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  Widget _makeTestableWidgetProvider(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Page should display TvSeriesDetailMain when opened',
        (WidgetTester tester) async {
      final tvSeriesDetailContentSectionFinder = find.byType(TvSeriesDetailMain);

      await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(
        id: 1,
      )));

      expect(tvSeriesDetailContentSectionFinder, findsOneWidget);
    },
  );

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(StateTvSeriesDetailLoaded());
        when(() => mockBloc.tvSeries).thenReturn(testTvSeriesDetail);
        when(() => mockBloc.tvSeriesRecommendations).thenReturn([testTvSeries]);
        when(() => mockBloc.isAddedToWatchlist).thenReturn(false);

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidgetProvider(TvSeriesDetailMain(
          id: tId,
        )));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when tv series not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(StateTvSeriesDetailLoaded());
        when(() => mockBloc.tvSeries).thenReturn(testTvSeriesDetail);
        when(() => mockBloc.tvSeriesRecommendations).thenReturn([testTvSeries]);
        when(() => mockBloc.isAddedToWatchlist).thenReturn(true);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidgetProvider(TvSeriesDetailMain(
          id: tId,
        )));

        expect(watchlistButtonIcon, findsOneWidget);
      });


}
