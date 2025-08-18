import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/favorites_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.showText = false,
  });

  final String mediaId;
  final String mediaType; // 'movie' | 'tv'
  final String title;
  final String? posterPath;
  final bool showText;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late final FavoritesApi _api;
  bool _isFavorite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api = FavoritesApi(ApiClient());
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        setState(() => _loading = false);
        return;
      }
      final isFav = await _api.checkFavorite(widget.mediaId);
      setState(() {
        _isFavorite = isFav;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Для добавления в избранное необходимо авторизоваться')),
      );
      return;
    }

    try {
      if (_isFavorite) {
        await _api.removeFavorite(widget.mediaId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Удалено из избранного')),
        );
      } else {
        await _api.addFavorite(
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
          title: widget.title,
          posterPath: widget.posterPath,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Добавлено в избранное')),
        );
      }
      setState(() => _isFavorite = !_isFavorite);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Произошла ошибка')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
    }

    final Color bgColor = _isFavorite ? Colors.red : const Color(0xFFE5D3BE);
    final Color textColor = _isFavorite ? Colors.red : const Color(0xFF8B5E3C);

    if (widget.showText) {
      return ElevatedButton.icon(
        onPressed: _toggleFavorite,
        icon: Icon(Icons.favorite, color: _isFavorite ? Colors.white : textColor),
        label: Text(_isFavorite ? 'В избранном' : 'В избранное'),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: _isFavorite ? Colors.white : textColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
    }

    return InkWell(
      onTap: _toggleFavorite,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          color: _isFavorite ? Colors.white : textColor,
          size: 20,
        ),
      ),
    );
  }
}