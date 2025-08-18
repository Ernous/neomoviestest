import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
      : _http = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.neomovies.ru');

  final http.Client _http;
  final String _baseUrl;

  Future<Map<String, String>> _buildHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final String clean = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$clean').replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final headers = await _buildHeaders();
    final response = await _http.get(_uri(path, query), headers: headers).timeout(const Duration(seconds: 30));
    return _unwrap(response);
  }

  Future<http.Response> post(String path, {Object? body, Map<String, dynamic>? query}) async {
    final headers = await _buildHeaders();
    final response = await _http
        .post(_uri(path, query), headers: headers, body: body is String ? body : jsonEncode(body))
        .timeout(const Duration(seconds: 30));
    return _unwrap(response);
  }

  Future<http.Response> delete(String path, {Map<String, dynamic>? query}) async {
    final headers = await _buildHeaders();
    final response = await _http.delete(_uri(path, query), headers: headers).timeout(const Duration(seconds: 30));
    return _unwrap(response);
  }

  http.Response _unwrap(http.Response response) {
    try {
      final dynamic parsed = jsonDecode(response.body);
      if (parsed is Map && parsed['success'] == true && parsed.containsKey('data')) {
        return http.Response(jsonEncode(parsed['data']), response.statusCode, headers: response.headers);
      }
      return response;
    } catch (_) {
      return response;
    }
  }
}

