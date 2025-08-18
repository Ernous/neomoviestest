import 'dart:convert';

import 'package:flutter_wasm_frontend/api/api_client.dart';

class ReactionsApi {
  ReactionsApi(this._client);
  final ApiClient _client;

  Future<Map<String, int>> getReactionCounts(String mediaType, String mediaId) async {
    final res = await _client.get('/api/v1/reactions/$mediaType/$mediaId/counts');
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, (value as num).toInt()));
  }

  Future<String?> getMyReaction(String mediaType, String mediaId) async {
    final res = await _client.get('/api/v1/reactions/$mediaType/$mediaId/my-reaction');
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['type'] as String?;
  }

  Future<void> setReaction(String mediaType, String mediaId, String type) async {
    final String fullMediaId = '${mediaType}_$mediaId';
    await _client.post('/api/v1/reactions', body: {'mediaId': fullMediaId, 'type': type});
  }

  Future<void> removeReaction(String mediaType, String mediaId) async {
    await _client.delete('/api/v1/reactions/$mediaType/$mediaId');
  }
}

