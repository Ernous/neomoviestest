import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late final NeoApi _api;
  List<MovieModel> _results = const <MovieModel>[];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = NeoApi(ApiClient());
  }

  Future<void> _search() async {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.multiSearch(q, page: 1);
      setState(() => _results = res.results);
    } catch (e) {
      setState(() => _error = 'Ошибка поиска: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final movie = _results[index];
                  return MovieCard(movie: movie, api: _api);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 68),
        child: FloatingActionButton.extended(
          onPressed: _search,
          icon: const Icon(Icons.search),
          label: const Text('Найти'),
        ),
      ),
    );
  }
}

