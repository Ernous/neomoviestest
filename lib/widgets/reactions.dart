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
  String? _userReaction; // 'fire', 'nice', 'think', 'bore', 'shit'
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
        : Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _ReactionButton(
                type: 'fire',
                icon: Icons.local_fire_department,
                count: _counts['fire'] ?? 0,
                active: _userReaction == 'fire',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('fire'),
              ),
              _ReactionButton(
                type: 'nice',
                icon: Icons.thumb_up,
                count: _counts['nice'] ?? 0,
                active: _userReaction == 'nice',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('nice'),
              ),
              _ReactionButton(
                type: 'think',
                icon: Icons.psychology,
                count: _counts['think'] ?? 0,
                active: _userReaction == 'think',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('think'),
              ),
              _ReactionButton(
                type: 'bore',
                icon: Icons.sentiment_neutral,
                count: _counts['bore'] ?? 0,
                active: _userReaction == 'bore',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('bore'),
              ),
              _ReactionButton(
                type: 'shit',
                icon: Icons.thumb_down,
                count: _counts['shit'] ?? 0,
                active: _userReaction == 'shit',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => _toggle('shit'),
              ),
            ],
          );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.type,
    required this.icon,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String type;
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? activeColor.withOpacity(0.3) : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: active ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text('$count', style: TextStyle(fontSize: 12, color: inactiveColor)),
      ],
    );
  }
}

