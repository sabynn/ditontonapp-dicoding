import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/popular_tvseries/popular_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/popular_tvseries_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../dummy_data/dummy_objects.dart';

class FakePopularTvSeriesEvent extends Fake implements PopularTvSeriesEvent {}

class FakePopularTvSeriesState extends Fake implements PopularTvSeriesState {}

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}
    
void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTvSeriesEvent());
    registerFallbackValue(FakePopularTvSeriesState());
  });

  setUp(() async {
    mockBloc = MockPopularTvSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('PopularTvSeriesMainPage should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(PopularTvSeriesInitial());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesMainPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('PopularTvSeriesMainPage should display when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(StatePopularTvSeriesLoaded());
        when(() => mockBloc.tvSeries).thenReturn(testTvSeriesList);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesMainPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets(
      'PopularTvSeriesMainPage should display text when Error',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
          StateLoadPopularTvSeriesFailure(message: 'Failure'),
        );

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesMainPage()));

        expect(textFinder, findsOneWidget);
      });
}
