import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/presentation/bloc/list_movie/list_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/list_tvseries/list_tvseries_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series/popular_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tv_series/search_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tvseries_page.dart';
import 'package:ditonton/presentation/pages/tv_series/tvseries_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series/watchlist_tvseries_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  final MovieListBloc movieBloc = locator();
  final TvSeriesListBloc tvSeriesBloc = locator();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('HomePage'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('TV Series Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseCrashlytics.instance.crash();
              _controller.index == 1
                  ? Navigator.pushNamed(context, SearchPage.ROUTE_NAME)
                  : Navigator.pushNamed(context, SearchTvSeriesPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TabBar(
                controller: _controller,
                indicatorColor: kMikadoYellow,
                tabs: [
                  Tab(
                    child: Text('TV Series'),
                  ),
                  Tab(
                    child: Text('Movie'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBarView(
                  controller: _controller,
                  children: [
                    BlocProvider(
                      create: (context) => tvSeriesBloc,
                      child: TvSeriesMenu(),
                    ),
                    BlocProvider(
                      create: (context) => movieBloc,
                      child: MovieMenu(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieMenu extends StatefulWidget {
  const MovieMenu({Key? key}) : super(key: key);

  @override
  State<MovieMenu> createState() => _MovieMenuState();
}

class _MovieMenuState extends State<MovieMenu> {
  late MovieListBloc movieListBloc;

  @override
  void initState() {
    super.initState();
    movieListBloc = BlocProvider.of<MovieListBloc>(context);
    movieListBloc.add(EventLoadMovieList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          BlocBuilder(
            bloc: movieListBloc,
            builder: (context, state) {
              if (state is StateMovieListInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StateMovieListLoaded) {
                return MovieList(movieListBloc.nowPlayingMovies);
              } else {
                return Text('Failed');
              }
            },
          ),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder(
              bloc: movieListBloc,
              builder: (context, state) {
                if (state is StateMovieListInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is StateMovieListLoaded) {
                  return MovieList(movieListBloc.popularMovies);
                } else {
                  return Text('Failed');
                }
              }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder(
              bloc: movieListBloc,
              builder: (context, state) {
                if (state is StateMovieListInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is StateMovieListLoaded) {
                  return MovieList(movieListBloc.topRatedMovies);
                } else {
                  return Text('Failed');
                }
              }),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesMenu extends StatefulWidget {
  @override
  State<TvSeriesMenu> createState() => _TvSeriesMenuState();
}

class _TvSeriesMenuState extends State<TvSeriesMenu> {
  late TvSeriesListBloc tvSeriesListBloc;

  @override
  void initState() {
    tvSeriesListBloc = BlocProvider.of<TvSeriesListBloc>(context);
    tvSeriesListBloc.add(EventLoadTvSeriesList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Airing Today',
            style: kHeading6,
          ),
          BlocBuilder(
            bloc: tvSeriesListBloc,
            builder: (context, state) {
              if (state is StateTvSeriesListInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StateTvSeriesListLoaded) {
                return TvSeriesList(tvSeriesListBloc.nowPlayingTvSeries);
              } else {
                return Text('Failed');
              }
            },
          ),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder(
            bloc: tvSeriesListBloc,
            builder: (context, state) {
              if (state is StateTvSeriesListInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StateTvSeriesListLoaded) {
                return TvSeriesList(tvSeriesListBloc.popularTvSeries);
              } else {
                return Text('Failed');
              }
            },
          ),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder(
            bloc: tvSeriesListBloc,
            builder: (context, state) {
              if (state is StateTvSeriesListInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is StateTvSeriesListLoaded) {
                return TvSeriesList(tvSeriesListBloc.topRatedTvSeries);
              } else {
                return Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSerie = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSerie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSerie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
