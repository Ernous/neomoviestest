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
  final NeoApi _api = NeoApi(ApiClient());
  Map<String, dynamic>? _tvShow;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTVShow();
  }

  Future<void> _loadTVShow() async {
    setState(() => _loading = true);
    try {
      final tvShow = await _api.tvDetails(widget.id);
      setState(() {
        _tvShow = tvShow;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки: $e';
        _loading = false;
      });
    }
  }

  Future<void> _openPlayer() async {
    if (_tvShow == null) return;
    
    final imdbId = _tvShow!['imdb_id'];
    if (imdbId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IMDb ID не найден')),
      );
      return;
    }

    // Open player URL in new tab
    final url = Uri.parse('https://api.neomovies.ru/api/v1/players/alloha/$imdbId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть плеер')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderBar(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _tvShow == null
                        ? const Center(child: Text('Сериал не найден'))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TV show poster and info
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Poster
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _api.imageUrl(_tvShow!['poster_path']).toString(),
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 120,
                                            height: 180,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.tv, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // TV show details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _tvShow!['name'] ?? 'Без названия',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          
                                          if (_tvShow!['tagline'] != null) ...[
                                            Text(
                                              _tvShow!['tagline'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          
                                          Text(
                                            _tvShow!['overview'] ?? 'Описание отсутствует',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Rating and seasons
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getRatingColor(_tvShow!['vote_average'] ?? 0),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '${(_tvShow!['vote_average'] ?? 0).toStringAsFixed(1)}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              if (_tvShow!['number_of_seasons'] != null)
                                                Text(
                                                  '${_tvShow!['number_of_seasons']} сезонов',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // First air date
                                          if (_tvShow!['first_air_date'] != null)
                                            Text(
                                              'Премьера: ${_tvShow!['first_air_date']}',
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Actions
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _openPlayer,
                                      icon: const Icon(Icons.play_arrow),
                                      label: const Text('Смотреть'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE04E39),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Reactions
                                Reactions(
                                  mediaId: widget.id,
                                  mediaType: 'tv',
                                ),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7) return Colors.green;
    if (rating >= 5) return Colors.orange;
    return Colors.red;
  }
}