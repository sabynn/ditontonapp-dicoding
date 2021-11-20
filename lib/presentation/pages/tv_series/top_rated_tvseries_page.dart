import 'package:ditonton/presentation/bloc/top_rated_tvseries/top_rated_tvseries_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatelessWidget{
  static const ROUTE_NAME = '/top-rated-tv-series';
  final TopRatedTvSeriesBloc topRatedTvSeriesBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => topRatedTvSeriesBloc,
      child: SafeArea(
        child: TopRatedTvSeriesMainPage(),
      ),
    );
  }
}

class TopRatedTvSeriesMainPage extends StatefulWidget {
  @override
  _TopRatedTvSeriesMainPageState createState() => _TopRatedTvSeriesMainPageState();
}

class _TopRatedTvSeriesMainPageState extends State<TopRatedTvSeriesMainPage> {
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;

  @override
  void initState() {
    super.initState();
    topRatedTvSeriesBloc = BlocProvider.of<TopRatedTvSeriesBloc>(context);
    topRatedTvSeriesBloc.add(EventLoadTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: topRatedTvSeriesBloc,
          builder: (context, state) {
            if (state is TopRatedTvSeriesInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StateTopRatedTvSeriesLoaded &&
                topRatedTvSeriesBloc.tvSeries.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No Top Rated TvSeries Available"),
              );
            } else if (state is StateTopRatedTvSeriesLoaded &&
                topRatedTvSeriesBloc.tvSeries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = topRatedTvSeriesBloc.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: topRatedTvSeriesBloc.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(topRatedTvSeriesBloc.message ?? "Failure"),
              );
            }
          },
        ),
      ),
    );
  }
}
