import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/reactions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reactions extends StatefulWidget {
  const Reactions({super.key, required this.mediaId, required this.mediaType});

  final String mediaId;
  final String mediaType; // 'movie' | 'tv'

  @override
  State<Reactions> createState() => _ReactionsState();
}

class _ReactionsState extends State<Reactions> {
  late final ReactionsApi _api;
  Map<String, int> _counts = const <String, int>{};
  String? _userReaction; // 'like' | 'dislike'
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api = ReactionsApi(ApiClient());
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final counts = await _api.getReactionCounts(widget.mediaType, widget.mediaId);
      String? userReaction;
      if (token != null && token.isNotEmpty) {
        userReaction = await _api.getMyReaction(widget.mediaType, widget.mediaId);
      }
      setState(() {
        _counts = counts;
        _userReaction = userReaction;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggle(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Войдите в аккаунт, чтобы ставить реакции')));
      return;
    }

    final String? old = _userReaction;
    final Map<String, int> prev = Map<String, int>.from(_counts);
    setState(() {
      if (old == type) {
        _userReaction = null;
        _counts[type] = (_counts[type] ?? 1) - 1;
      } else {
        _userReaction = type;
        _counts[type] = (_counts[type] ?? 0) + 1;
        if (old != null) {
          _counts[old] = (_counts[old] ?? 1) - 1;
        }
      }
    });

    try {
      await _api.setReaction(widget.mediaType, widget.mediaId, type);
    } catch (_) {
      setState(() {
        _userReaction = old;
        _counts = prev;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не удалось сохранить реакцию')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Theme.of(context).brightness == Brightness.dark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF);
    return _loading && _counts.isEmpty
        ? const Text('Загрузка реакций...')
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ReactionButton(
                label: 'Нравится',
                icon: Icons.thumb_up,
                count: _counts['like'] ?? 0,
                active: _userReaction == 'like',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('like'),
              ),
              const SizedBox(width: 12),
              _ReactionButton(
                label: 'Не нравится',
                icon: Icons.thumb_down,
                count: _counts['dislike'] ?? 0,
                active: _userReaction == 'dislike',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('dislike'),
              ),
            ],
          );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.label,
    required this.icon,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final int count;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 64,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? activeColor.withOpacity(0.3) : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: active ? activeColor : inactiveColor),
          ),
        ),
        const SizedBox(height: 4),
        Text('$count', style: TextStyle(fontSize: 12, color: inactiveColor)),
      ],
    );
  }
}

