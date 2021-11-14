import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
  TvSeriesDetailResponse({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.lastAirDate,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final String firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String lastAirDate;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final double popularity;
  final String status;
  final String tagline;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from( json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        overview: json["overview"],
        name: json["name"],
        originalName : json["original_name"],
        popularity: json['popularity'],
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"],
        lastAirDate: json["last_air_date"],
        status: json["status"],
        tagline: json["tagline"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "first_air_date": firstAirDate,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "id": id,
    "last_air_date": lastAirDate,
    "name": name,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "status": status,
    "tagline": tagline,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      backdropPath: this.backdropPath,
      firstAirDate: this.firstAirDate,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id : this.id,
      lastAirDate: this.lastAirDate,
      name: this.name,
      originalName: this.originalName,
      overview: this.overview,
      posterPath: this.posterPath,
      status: this.status,
      tagline: this.tagline,
      voteCount: this.voteCount,
      voteAverage: this.voteAverage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genres,
    id,
    lastAirDate,
    name,
    originalName,
    overview,
    popularity,
    posterPath,
    status,
    tagline,
    voteAverage,
    voteCount,
  ];
}
