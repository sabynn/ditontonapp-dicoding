enum RequestState { Empty, Loading, Loaded, Error }
enum CategoryMenu { Movie, TvSeries }
enum SeeMoreState { Popular, TopRated }

const Map<CategoryMenu, String> categoryMenuValues = {
  CategoryMenu.Movie: 'movie',
  CategoryMenu.TvSeries: 'tv_series',
};
