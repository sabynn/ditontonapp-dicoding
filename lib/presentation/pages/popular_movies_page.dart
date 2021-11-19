import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-movie';
  final PopularMovieBloc popularMovieBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => popularMovieBloc,
      child: SafeArea(
        child: PopularMovieMainPage(),
      ),
    );
  }
}

class PopularMovieMainPage extends StatefulWidget {
  @override
  _PopularMovieMainPageState createState() => _PopularMovieMainPageState();
}

class _PopularMovieMainPageState extends State<PopularMovieMainPage> {
  late PopularMovieBloc popularMovieBloc;

  @override
  void initState() {
    popularMovieBloc = BlocProvider.of<PopularMovieBloc>(context);
    popularMovieBloc.add(EventLoadPopularMovie());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: popularMovieBloc,
          builder: (context, state) {
            if (state is PopularMovieInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StatePopularMovieLoaded &&
                popularMovieBloc.movies.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No Popular Movie Available"),
              );
            } else if (state is StatePopularMovieLoaded &&
                popularMovieBloc.movies.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = popularMovieBloc.movies[index];
                  return MovieCard(movie);
                },
                itemCount: popularMovieBloc.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(popularMovieBloc.message),
              );
            }
          },
        ),
      ),
    );
  }
}
