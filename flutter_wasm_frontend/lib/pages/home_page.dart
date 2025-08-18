import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/movie_card.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: const HeaderBar(),
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
                      return MovieCard(movie: movie, api: _api);
                    },
                  ),
      ),
    );
  }
}
