class GenreModel {
  const GenreModel({required this.id, required this.name});
  final int id;
  final String name;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
      );
}

class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    this.runtime,
    this.genres,
    this.popularity,
    this.mediaType,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final int? runtime;
  final List<GenreModel>? genres;
  final double? popularity;
  final String? mediaType;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: (json['id'] as num).toInt(),
        title: (json['title'] ?? json['name'] ?? '') as String,
        overview: (json['overview'] ?? '') as String,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        releaseDate: (json['release_date'] ?? json['first_air_date'] ?? '') as String,
        voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
        voteCount: (json['vote_count'] as num? ?? 0).toInt(),
        genreIds: (json['genre_ids'] as List?)?.map((e) => (e as num).toInt()).toList() ?? const <int>[],
        runtime: (json['runtime'] as num?)?.toInt(),
        genres: (json['genres'] as List?)?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>)).toList(),
        popularity: (json['popularity'] as num?)?.toDouble(),
        mediaType: json['media_type'] as String?,
      );
}

class MovieResponse {
  const MovieResponse({required this.page, required this.results, required this.totalPages, required this.totalResults});

  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        page: (json['page'] as num).toInt(),
        results: (json['results'] as List).map((e) => MovieModel.fromJson(e as Map<String, dynamic>)).toList(),
        totalPages: (json['total_pages'] as num).toInt(),
        totalResults: (json['total_results'] as num).toInt(),
      );
}

