import 'package:ditonton/presentation/bloc/popular_tvseries/popular_tvseries_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-tv-series';
  final PopularTvSeriesBloc popularTvSeriesBloc = locator();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => popularTvSeriesBloc,
      child: SafeArea(
        child: PopularTvSeriesMainPage(),
      ),
    );
  }
}


class PopularTvSeriesMainPage extends StatefulWidget {
  @override
  _PopularTvSeriesMainPageState createState() => _PopularTvSeriesMainPageState();
}

class _PopularTvSeriesMainPageState extends State<PopularTvSeriesMainPage> {
  late PopularTvSeriesBloc popularTvSeriesBloc;

  @override
  void initState() {
    popularTvSeriesBloc = BlocProvider.of<PopularTvSeriesBloc>(context);
    popularTvSeriesBloc.add(EventLoadPopularTvSeries());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TvSeries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder(
          bloc: popularTvSeriesBloc,
          builder: (context, state) {
            if (state is PopularTvSeriesInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StatePopularTvSeriesLoaded &&
                popularTvSeriesBloc.tvSeries.isEmpty) {
              return Center(
                key: Key('empty_message'),
                child: Text("No Popular Tv Series Available"),
              );
            } else if (state is StatePopularTvSeriesLoaded &&
                popularTvSeriesBloc.tvSeries.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = popularTvSeriesBloc.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: popularTvSeriesBloc.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(popularTvSeriesBloc.message),
              );
            }
          },
        ),
      ),
    );
  }
}
