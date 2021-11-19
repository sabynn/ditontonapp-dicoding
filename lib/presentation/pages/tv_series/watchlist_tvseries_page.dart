import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/watchlist_tvseries/watchlist_tvseries_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WatchlistTvSeriesPage extends StatelessWidget{
  static const ROUTE_NAME = '/watchlist-tv-series';
  WatchlistTvSeriesBloc watchlistTvSeriesBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => watchlistTvSeriesBloc,
      child: SafeArea(
        child: WatchlistTvSeriesMainPage(),
      ),
    );
  }
}

class WatchlistTvSeriesMainPage extends StatefulWidget {
  @override
  _WatchlistTvSeriesMainPageState createState() => _WatchlistTvSeriesMainPageState();
}

class _WatchlistTvSeriesMainPageState extends State<WatchlistTvSeriesMainPage>
    with RouteAware {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc ;

  @override
  void initState() {
    super.initState();
    watchlistTvSeriesBloc = BlocProvider.of<WatchlistTvSeriesBloc>(context);
    watchlistTvSeriesBloc.add(EventLoadWatchlistTvSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    watchlistTvSeriesBloc.add(EventLoadWatchlistTvSeries());
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
          bloc: watchlistTvSeriesBloc,
          builder: (context, state) {
            if (state is WatchlistTvSeriesInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StateWatchlistTvSeriesLoaded &&
                watchlistTvSeriesBloc.tvSeries.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No TvSeries Watchlist Available"),
              );
            } else if (state is StateWatchlistTvSeriesLoaded &&
                watchlistTvSeriesBloc.tvSeries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = watchlistTvSeriesBloc.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: watchlistTvSeriesBloc.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(watchlistTvSeriesBloc.message),
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
