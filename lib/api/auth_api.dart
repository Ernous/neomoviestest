import 'dart:convert';

import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _client.post('/api/v1/auth/login', body: <String, dynamic>{'email': email, 'password': password});
    final Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
    final String token = (data['token'] ?? data['accessToken'] ?? '') as String;
    if (token.isEmpty) {
      throw Exception('Токен не получен');
    }
    // Store token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // Return response data
    return data;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

