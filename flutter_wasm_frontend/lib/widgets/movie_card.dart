import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/neo_api.dart';
import 'package:flutter_wasm_frontend/models/movie.dart';
import 'package:go_router/go_router.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.api, this.priority = false});

  final MovieModel movie;
  final NeoApi api;
  final bool priority;

  Color _ratingColor(double rating) {
    if (rating >= 7) return const Color(0xFF16A34A); // green-600
    if (rating >= 5) return const Color(0xFFF59E0B); // yellow-500
    return const Color(0xFFDC2626); // red-600
  }

  @override
  Widget build(BuildContext context) {
    final image = api.imageUrl(movie.posterPath, size: 'w342');
    return InkWell(
      onTap: () => context.go('/movie/${movie.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Color(0x33000000))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(image.toString(), fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: _ratingColor(movie.voteAverage),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x66000000))],
                      ),
                      child: Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.isEmpty ? 'Без названия' : movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.releaseDate.isEmpty ? 'Без даты' : movie.releaseDate,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
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

