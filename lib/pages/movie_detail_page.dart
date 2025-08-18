import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/favorite_button.dart';
import 'package:flutter_wasm_frontend/widgets/reactions.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.id});

  final String id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final NeoApi _api = NeoApi(ApiClient());
  Map<String, dynamic>? _movie;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }

  Future<void> _loadMovie() async {
    setState(() => _loading = true);
    try {
      final movie = await _api.movieDetails(widget.id);
      setState(() {
        _movie = movie;
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
    if (_movie == null) return;
    
    final imdbId = _movie!['imdb_id'];
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
                    : _movie == null
                        ? const Center(child: Text('Фильм не найден'))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Movie poster and info
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Poster
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _api.imageUrl(_movie!['poster_path']).toString(),
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 120,
                                            height: 180,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.movie, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Movie details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _movie!['title'] ?? 'Без названия',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          
                                          if (_movie!['tagline'] != null) ...[
                                            Text(
                                              _movie!['tagline'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                          
                                          Text(
                                            _movie!['overview'] ?? 'Описание отсутствует',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Rating and runtime
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getRatingColor(_movie!['vote_average'] ?? 0),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '${(_movie!['vote_average'] ?? 0).toStringAsFixed(1)}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              if (_movie!['runtime'] != null)
                                                Text(
                                                  '${_movie!['runtime']} мин',
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Release date
                                          if (_movie!['release_date'] != null)
                                            Text(
                                              'Дата выхода: ${_movie!['release_date']}',
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
                                    FavoriteButton(
                                      mediaId: widget.id,
                                      mediaType: 'movie',
                                      title: _movie!['title'] ?? '',
                                      posterPath: _movie!['poster_path'],
                                    ),
                                    const SizedBox(width: 16),
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
                                  mediaType: 'movie',
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

