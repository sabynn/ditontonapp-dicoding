import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_tvseries/watchlist_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/watchlist_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/injection.dart' as di;

import '../../../dummy_data/dummy_objects.dart';

class FakeWatchlistTvSeriesEvent extends Fake
    implements WatchlistTvSeriesEvent {}

class FakeWatchlistTvSeriesState extends Fake
    implements WatchlistTvSeriesState {}

class MockWatchlistTvSeriesBloc
    extends MockBloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState>
    implements WatchlistTvSeriesBloc {}

void main() {
  late WatchlistTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvSeriesEvent());
    registerFallbackValue(FakeWatchlistTvSeriesState());
  });

  setUp(() async {
    await GetIt.I.reset();
    di.init();
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTvSeriesInitial(),
    );

    final centerFinder = find.byType(Center);
    final progressFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvSeriesMainPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display listview when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(StateWatchlistTvSeriesLoaded());
    when(() => mockBloc.tvSeries).thenReturn(testTvSeriesList);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvSeriesMainPage()));

    expect(listViewFinder, findsOneWidget);
  });
}
