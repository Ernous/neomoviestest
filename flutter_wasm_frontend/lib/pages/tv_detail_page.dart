import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/reactions.dart';
import 'package:url_launcher/url_launcher.dart';

class TVDetailPage extends StatefulWidget {
  const TVDetailPage({super.key, required this.id});

  final String id;

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
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
      final data = await _api.tvDetails(widget.id);
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
      appBar: const HeaderBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_details?['poster_path'] != null)
                              Container(
                                width: 200,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(_api.imageUrl(_details!['poster_path']).toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _details?['name']?.toString() ?? 'Без названия',
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                  ),
                                  if (_details?['tagline'] != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      _details?['tagline'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text('Рейтинг: ${_details?['vote_average']?.toStringAsFixed(1) ?? '0.0'}'),
                                      const SizedBox(width: 16),
                                      Text('Сезонов: ${_details?['number_of_seasons'] ?? 0}'),
                                      const SizedBox(width: 16),
                                      Text(_details?['first_air_date']?.toString() ?? 'Без даты'),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (_details?['overview'] != null) ...[
                                    Text(
                                      _details?['overview'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (_playerUrl != null) ...[
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await launchUrl(_playerUrl!, mode: LaunchMode.externalApplication);
                                      },
                                      icon: const Icon(Icons.play_circle),
                                      label: const Text('Смотреть'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  Reactions(mediaId: widget.id, mediaType: 'tv'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}