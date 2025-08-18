import 'dart:convert';

import 'package:flutter_wasm_frontend/api/api_client.dart';

class FavoritesApi {
  FavoritesApi(this._client);
  final ApiClient _client;

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final res = await _client.get('/api/v1/favorites');
    final dynamic data = jsonDecode(res.body);
    if (data is List) return data.cast<Map<String, dynamic>>();
    return const <Map<String, dynamic>>[];
  }

  Future<void> addFavorite({required String mediaId, required String mediaType, required String title, String? posterPath}) async {
    await _client.post('/api/v1/favorites/$mediaId', query: {'mediaType': mediaType}, body: {
      'title': title,
      if (posterPath != null) 'posterPath': posterPath,
    });
  }

  Future<void> removeFavorite(String mediaId) async {
    await _client.delete('/api/v1/favorites/$mediaId');
  }

  Future<bool> checkFavorite(String mediaId) async {
    final res = await _client.get('/api/v1/favorites/check/$mediaId');
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['exists'] as bool?) ?? false;
  }
}

