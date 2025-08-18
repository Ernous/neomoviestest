import 'dart:convert';

import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/models/category.dart';

class NeoApi {
  NeoApi(this._client);

  final ApiClient _client;

  Uri imageUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) {
      return Uri.parse('/images/placeholder.jpg');
    }
    if (path.startsWith('http')) {
      return Uri.parse(path);
    }
    final String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.neomovies.ru')}/api/v1/images/$size/$cleanPath');
  }

  // Movies
  Future<MovieResponse> moviePopular({int page = 1}) async {
    final res = await _client.get('/api/v1/movies/popular', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> moviesPopular({int page = 1}) async {
    return moviePopular(page: page);
  }

  Future<MovieResponse> moviesTopRated({int page = 1}) async {
    final res = await _client.get('/api/v1/movies/top-rated', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> moviesNowPlaying({int page = 1}) async {
    final res = await _client.get('/api/v1/movies/now-playing', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> moviesUpcoming({int page = 1}) async {
    final res = await _client.get('/api/v1/movies/upcoming', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> movieDetails(String id) async {
    final res = await _client.get('/api/v1/movies/$id');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    final res = await _client.get('/api/v1/movies/search', query: {'query': query, 'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> search(String query, {int page = 1}) async {
    return multiSearch(query, page: page);
  }

  Future<MovieResponse> multiSearch(String query, {int page = 1}) async {
    final res = await _client.get('/search/multi', query: {'query': query, 'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // TV Shows
  Future<MovieResponse> tvPopular({int page = 1}) async {
    final res = await _client.get('/api/v1/tv/popular', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> tvTopRated({int page = 1}) async {
    final res = await _client.get('/api/v1/tv/top-rated', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> tvOnTheAir({int page = 1}) async {
    final res = await _client.get('/api/v1/tv/on-the-air', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> tvAiringToday({int page = 1}) async {
    final res = await _client.get('/api/v1/tv/airing-today', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> tvDetails(String id) async {
    final res = await _client.get('/api/v1/tv/$id');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // Categories
  Future<CategoryResponse> categories() async {
    final res = await _client.get('/api/v1/categories');
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    return CategoryResponse.fromJson(data);
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await categories();
    return response.categories;
  }

  Future<MovieResponse> getMoviesByCategory(int categoryId, {int page = 1}) async {
    final res = await _client.get('/api/v1/categories/$categoryId/movies', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<MovieResponse> getTVByCategory(int categoryId, {int page = 1}) async {
    final res = await _client.get('/api/v1/categories/$categoryId/tv', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}

