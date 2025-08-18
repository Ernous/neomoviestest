import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56 + 48);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        children: const [
                          TextSpan(text: 'Neo'),
                          TextSpan(text: 'Movies', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onSubmitted: (q) {
                                final query = q.trim();
                                if (query.isNotEmpty) context.go('/search?q=${Uri.encodeQueryComponent(query)}');
                              },
                              decoration: const InputDecoration(
                                hintText: 'Поиск фильмов и сериалов...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(onPressed: () => context.go('/settings'), icon: const Icon(Icons.settings)),
                  const SizedBox(width: 4),
                  TextButton(onPressed: () => context.go('/login'), child: const Text('Вход')),
                ],
              ),
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavLink(label: 'Фильмы', path: '/'),
                const SizedBox(width: 24),
                _NavLink(label: 'Категории', path: '/categories'),
                const SizedBox(width: 24),
                _NavLink(label: 'Избранное', path: '/favorites'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.path});
  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final bool active = location == path;
    return InkWell(
      onTap: () => context.go(path),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active ? const Color(0xFFe04e39) : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}

