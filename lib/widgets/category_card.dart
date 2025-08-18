import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/models/category.dart';
import 'package:go_router/go_router.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, this.backgroundUrl});

  final CategoryModel category;
  final String? backgroundUrl;

  Color _genreColor(int id) {
    switch (id) {
      case 28:
        return const Color(0xFFE53935);
      case 12:
        return const Color(0xFF43A047);
      case 16:
        return const Color(0xFFFB8C00);
      case 35:
        return const Color(0xFFFFEE58);
      case 80:
        return const Color(0xFF424242);
      case 99:
        return const Color(0xFF8D6E63);
      case 18:
        return const Color(0xFF5E35B1);
      case 10751:
        return const Color(0xFFEC407A);
      case 14:
        return const Color(0xFF7E57C2);
      case 36:
        return const Color(0xFF795548);
      case 27:
        return const Color(0xFF212121);
      case 10402:
        return const Color(0xFF26A69A);
      case 9648:
        return const Color(0xFF5C6BC0);
      case 10749:
        return const Color(0xFFEC407A);
      case 878:
        return const Color(0xFF00BCD4);
      case 10770:
        return const Color(0xFF9E9E9E);
      case 53:
        return const Color(0xFFFFA000);
      case 10752:
        return const Color(0xFF455A64);
      case 37:
        return const Color(0xFF8D6E63);
      case 10759:
        return const Color(0xFF1E88E5);
      case 10762:
        return const Color(0xFF00ACC1);
      case 10763:
        return const Color(0xFF546E7A);
      case 10764:
        return const Color(0xFFF06292);
      case 10765:
        return const Color(0xFF00BCD4);
      case 10766:
        return const Color(0xFF5E35B1);
      case 10767:
        return const Color(0xFF4CAF50);
      case 10768:
        return const Color(0xFFFFD54F);
      default:
        return const Color(0xFF3949AB);
    }
  }

  Uri _imageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return Uri.parse('/images/placeholder.jpg');
    }
    if (path.startsWith('http')) {
      return Uri.parse(path);
    }
    final String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('https://api.neomovies.ru/api/v1/images/w500/$cleanPath');
  }

  @override
  Widget build(BuildContext context) {
    final String image = backgroundUrl ?? '/images/placeholder.jpg';
    final Color color = _genreColor(category.id);
    return InkWell(
      onTap: () => context.go('/categories/${category.id}'),
      child: Container(
        height: 176,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 0.7,
              child: Container(color: color),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0x99000000), Color(0x33000000), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

