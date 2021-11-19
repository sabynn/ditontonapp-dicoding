import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatelessWidget{
  static const ROUTE_NAME = '/top-rated-movie';
  final TopRatedMovieBloc topRatedMovieBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => topRatedMovieBloc,
      child: SafeArea(
        child: TopRatedMoviesMainPage(),
      ),
    );
  }
}

class TopRatedMoviesMainPage extends StatefulWidget {
  @override
  _TopRatedMoviesMainPageState createState() => _TopRatedMoviesMainPageState();
}

class _TopRatedMoviesMainPageState extends State<TopRatedMoviesMainPage> {
  late TopRatedMovieBloc topRatedMovieBloc;
  
  @override
  void initState() {
    topRatedMovieBloc = BlocProvider.of<TopRatedMovieBloc>(context);
    topRatedMovieBloc.add(EventLoadTopRatedMovie());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: topRatedMovieBloc,
          builder: (context, state) {
            if (state is TopRatedMovieInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StateTopRatedMovieLoaded &&
                topRatedMovieBloc.movies.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No Top Rated Movie Available"),
              );
            } else if (state is StateTopRatedMovieLoaded &&
                topRatedMovieBloc.movies.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = topRatedMovieBloc.movies[index];
                  return MovieCard(movie);
                },
                itemCount: topRatedMovieBloc.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(topRatedMovieBloc.message),
              );
            }
          },
        ),
      ),
    );
  }
}
