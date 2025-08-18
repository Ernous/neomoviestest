import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/movie_card.dart';
import 'package:flutter_wasm_frontend/widgets/pagination.dart';

class TVPage extends StatefulWidget {
  const TVPage({super.key});

  @override
  State<TVPage> createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  late final NeoApi _api;
  bool _loading = true;
  String? _error;
  List<MovieModel> _popular = const <MovieModel>[];
  int _currentPage = 1;
  int _totalPages = 1;

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
      final res = await _api.tvPopular(page: _currentPage);
      setState(() {
        _popular = res.results;
        _totalPages = res.totalPages;
      });
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onPageChange(int page) {
    setState(() => _currentPage = page);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Сериалы', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_loading)
                const Center(child: CircularProgressIndicator())
            else if (_error != null)
                Center(child: Text(_error!))
            else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: _popular.length,
                          itemBuilder: (context, index) {
                            final movie = _popular[index];
                            return MovieCard(movie: movie, api: _api);
                          },
                        ),
                      ),
                      if (_totalPages > 1)
                        Pagination(
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          onPageChange: _onPageChange,
                        ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}