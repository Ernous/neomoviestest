import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.id});

  final String id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late final NeoApi _api;
  Map<String, dynamic>? _details;
  bool _loading = true;
  String? _error;
  String? _imdbId;
  Uri? _playerUrl;

  @override
  void initState() {
    super.initState();
    _api = NeoApi(ApiClient());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.movieDetails(widget.id);
      _details = data;
      _imdbId = (data['imdb_id'] as String?) ?? '';
      final String base = const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.neomovies.ru');
      final String endpoint = '/api/v1/players/alloha';
      if (_imdbId != null && _imdbId!.isNotEmpty) {
        _playerUrl = Uri.parse('$base$endpoint/${_imdbId!}');
      }
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Фильм ${widget.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_details?['title']?.toString() ?? 'Без названия',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (_playerUrl == null)
                        const Expanded(child: Center(child: Text('Плеер недоступен')))
                      else
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Открыть плеер в новой вкладке'),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_playerUrl != null) {
                                      await launchUrl(_playerUrl!, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Открыть плеер'),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}

// Note: iframe embedding removed for WASM compatibility.

