import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:flutter_wasm_frontend/widgets/movie_card.dart';
import 'package:flutter_wasm_frontend/widgets/pagination.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final NeoApi _api = NeoApi(ApiClient());
  List<MovieModel> _results = [];
  bool _loading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    final query = uri.queryParameters['q'];
    if (query != null && query != _query) {
      _query = query;
      _currentPage = 1;
      _search();
    }
  }

  Future<void> _search() async {
    if (_query.trim().isEmpty) return;
    
    setState(() => _loading = true);
    try {
      final response = await _api.search(_query, page: _currentPage);
      setState(() {
        _results = response.results;
        _totalPages = response.totalPages;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка поиска: $e')),
        );
      }
    }
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderBar(),
          Expanded(
            child: _query.isEmpty
                ? const Center(child: Text('Введите поисковый запрос'))
                : _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? const Center(child: Text('Ничего не найдено'))
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Результаты поиска: $_query',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: _results.length,
                                  itemBuilder: (context, index) {
                                    return MovieCard(movie: _results[index]);
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

