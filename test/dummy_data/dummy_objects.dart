import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series/tvseries_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvSeries = TvSeries(
  backdropPath: "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
  firstAirDate: "2011-04-17",
  idGenre: [10765, 18, 10759, 9648],
  id: 1399,
  name: "Game of Thrones",
  originalCountry: ["US"],
  originalLanguage: "en",
  originalName: "Game of Thrones",
  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  popularity: 369.594,
  posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
  voteAverage: 8.3,
  voteCount: 11504,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  originalName: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
  firstAirDate: 'firstAirDate',
  status: 'ended',
  tagline: 'tagline',
  lastAirDate: 'lastAirDate',
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
