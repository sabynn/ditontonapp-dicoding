import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class FakeTopRatedMovieEvent extends Fake implements TopRatedMovieEvent {}

class FakeTopRatedMovieState extends Fake implements TopRatedMovieState {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

void main() {
  late MockTopRatedMovieBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMovieEvent());
    registerFallbackValue(FakeTopRatedMovieState());
  });

  setUp(() async {
    mockBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('TopRatedMovieList should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(TopRatedMovieInitial());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesMainPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('TopRatedMovieList should display listview when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(StateTopRatedMovieLoaded());
        when(() => mockBloc.movies).thenReturn(testMovieList);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesMainPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('TopRatedMovieList should display text when Error',
          (WidgetTester tester) async {
        when(() => mockBloc.state)
            .thenReturn(StateLoadTopRatedMovieFailure(message: 'Failure'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesMainPage()));

        expect(textFinder, findsOneWidget);
      });
}
