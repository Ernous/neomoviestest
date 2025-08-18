import 'dart:convert';

import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';

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

  Future<MovieResponse> moviesPopular({int page = 1}) async {
    final res = await _client.get('/api/v1/movies/popular', query: {'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
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

  Future<MovieResponse> multiSearch(String query, {int page = 1}) async {
    final res = await _client.get('/search/multi', query: {'query': query, 'page': page});
    return MovieResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}

