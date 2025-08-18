import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/movie_card.dart';
import 'package:flutter_wasm_frontend/widgets/pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NeoApi _api = NeoApi(ApiClient());
  List<MovieModel> _movies = [];
  bool _loading = true;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _loading = true);
    try {
      final response = await _api.moviePopular(page: _currentPage);
      setState(() {
        _movies = response.results;
        _totalPages = response.totalPages;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _loadMovies();
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
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _movies.length,
                          itemBuilder: (context, index) {
                            return MovieCard(movie: _movies[index]);
                          },
                        ),
                      ),
                      if (_totalPages > 1)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Pagination(
                            currentPage: _currentPage,
                            totalPages: _totalPages,
                            onPageChanged: _onPageChanged,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
