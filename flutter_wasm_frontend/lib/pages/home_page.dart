import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NeoApi _api;
  bool _loading = true;
  String? _error;
  List<MovieModel> _popular = const <MovieModel>[];

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
      final MovieResponse res = await _api.moviesPopular(page: 1);
      setState(() {
        _popular = res.results.take(12).toList();
      });
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NeoMovies')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: _popular.length,
                    itemBuilder: (context, index) {
                      final movie = _popular[index];
                      return _MovieCard(movie: movie, api: _api);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/search'),
        child: const Icon(Icons.search),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, required this.api});

  final MovieModel movie;
  final NeoApi api;

  @override
  Widget build(BuildContext context) {
    final image = api.imageUrl(movie.posterPath);
    return InkWell(
      onTap: () => context.go('/movie/${movie.id}'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                image.toString(),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

