import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetAiringTodayTvSeries {
  final TvSeriesRepository repository;

  GetAiringTodayTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getAiringTodayTvSeries();
  }
}
