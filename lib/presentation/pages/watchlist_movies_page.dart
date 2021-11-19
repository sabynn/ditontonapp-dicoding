import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatelessWidget{
  static const ROUTE_NAME = '/watchlist-movie';
  WatchlistMovieBloc watchlistMovieBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => watchlistMovieBloc,
      child: SafeArea(
        child: WatchlistMoviesMainPage(),
      ),
    );
  }
}

class WatchlistMoviesMainPage extends StatefulWidget {
  @override
  _WatchlistMoviesMainPageState createState() => _WatchlistMoviesMainPageState();
}

class _WatchlistMoviesMainPageState extends State<WatchlistMoviesMainPage>
    with RouteAware {
  late WatchlistMovieBloc watchlistMovieBloc;

  @override
  void initState() {
    watchlistMovieBloc = BlocProvider.of<WatchlistMovieBloc>(context);
    watchlistMovieBloc.add(EventLoadWatchlistMovie());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    watchlistMovieBloc.add(EventLoadWatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: watchlistMovieBloc,
          builder: (context, state) {
            if (state is WatchlistMovieInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StateWatchlistMovieLoaded &&
                watchlistMovieBloc.movies.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No Movie Watchlist Available"),
              );
            } else if (state is StateWatchlistMovieLoaded &&
                watchlistMovieBloc.movies.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = watchlistMovieBloc.movies[index];
                  return MovieCard(movie);
                },
                itemCount: watchlistMovieBloc.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(watchlistMovieBloc.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
