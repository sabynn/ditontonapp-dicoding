import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/detail_movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class FakeDetailEvent extends Fake implements DetailMovieEvent {}

class FakeDetailState extends Fake implements DetailMovieState {}

class MockMovieDetailBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;
  int tId = 1;

  setUpAll(() {
    registerFallbackValue(FakeDetailEvent());
    registerFallbackValue(FakeDetailState());
  });

  setUp(() async {
    await GetIt.I.reset();
    await di.init();
    mockBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  Widget _makeTestableWidgetProvider(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Page should display MovieDetailMain when opened',
    (WidgetTester tester) async {
      final movieDetailContentSectionFinder = find.byType(MovieDetailMain);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: 1,
      )));

      expect(movieDetailContentSectionFinder, findsOneWidget);
    },
  );

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(StateMovieDetailLoaded());
    when(() => mockBloc.movie).thenReturn(testMovieDetail);
    when(() => mockBloc.movieRecommendations).thenReturn([testMovie]);
    when(() => mockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidgetProvider(MovieDetailMain(
      id: tId,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(StateMovieDetailLoaded());
    when(() => mockBloc.movie).thenReturn(testMovieDetail);
    when(() => mockBloc.movieRecommendations).thenReturn([testMovie]);
    when(() => mockBloc.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(
      _makeTestableWidgetProvider(
        MovieDetailMain(
          id: tId,
        ),
      ),
    );

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('MovieDetailMain should display text when load Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      StateLoadDetailMovieFailure(message: 'Failure'),
    );

    final textFinder = find.byType(Text);

    await tester.pumpWidget(
      _makeTestableWidgetProvider(
        MovieDetailMain(
          id: tId,
        ),
      ),
    );

    expect(textFinder, findsOneWidget);
  });

  testWidgets('MovieDetailMain should display text when watchlist Error',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(
          StateWatchlistFailure('Failure'),
        );

        final textFinder = find.byType(Text);

        await tester.pumpWidget(
          _makeTestableWidgetProvider(
            MovieDetailMain(
              id: tId,
            ),
          ),
        );

        expect(textFinder, findsOneWidget);
      });
}
