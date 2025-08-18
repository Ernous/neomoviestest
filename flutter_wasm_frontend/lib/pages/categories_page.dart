import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/category.dart';
import 'package:flutter_wasm_frontend/widgets/category_card.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final NeoApi _api;
  bool _loading = true;
  String? _error;
  List<CategoryModel> _categories = const <CategoryModel>[];
  final Map<int, String?> _backgrounds = <int, String?>{};

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
      final cats = await _api.getCategories();
      final Map<int, String?> bg = <int, String?>{};
      for (final c in cats) {
        try {
          final movies = await _api.getMoviesByCategory(c.id, page: 1);
          if (movies.results.isNotEmpty) {
            bg[c.id] = movies.results.first.backdropPath ?? movies.results.first.posterPath;
          } else {
            final tv = await _api.getTVByCategory(c.id, page: 1);
            if (tv.results.isNotEmpty) {
              bg[c.id] = tv.results.first.backdropPath ?? tv.results.first.posterPath;
            }
          }
        } catch (_) {}
      }
      setState(() {
        _categories = cats;
        _backgrounds.clear();
        _backgrounds.addAll(bg);
      });
    } catch (e) {
      setState(() => _error = 'Ошибка при загрузке категорий');
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
        child: _error != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Категории', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Категории', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Выберите категорию для просмотра фильмов', style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 16 / 9,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return CategoryCard(category: cat, backgroundUrl: _backgrounds[cat.id], api: _api);
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

