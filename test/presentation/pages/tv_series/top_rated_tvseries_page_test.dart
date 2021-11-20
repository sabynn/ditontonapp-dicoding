import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class FakeTopRatedTvSeriesEvent extends Fake implements TopRatedTvSeriesEvent {}

class FakeTopRatedTvSeriestate extends Fake implements TopRatedTvSeriesState {}

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvSeriesEvent());
    registerFallbackValue(FakeTopRatedTvSeriestate());
  });

  setUp(() async {
    mockBloc = MockTopRatedTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('TopRatedTvSeriesList should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(TopRatedTvSeriesInitial());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesMainPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('TopRatedTvSeriesList should display listview when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(StateTopRatedTvSeriesLoaded());
        when(() => mockBloc.tvSeries).thenReturn(testTvSeriesList);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesMainPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('TopRatedTvSeriesList should display text when Error',
          (WidgetTester tester) async {
        when(() => mockBloc.state)
            .thenReturn(StateLoadTopRatedTvSeriesFailure(message: 'Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesMainPage()));

        expect(textFinder, findsOneWidget);
      });
}
