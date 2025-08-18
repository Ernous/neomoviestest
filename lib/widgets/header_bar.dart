import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderBar extends StatefulWidget {
  const HeaderBar({super.key});

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  String? _userName;
  final TextEditingController _searchController = TextEditingController();
  bool _isDarkMode = true; // Default to dark mode

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
    // Note: In a real app, you'd want to use a proper theme provider
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.go('/search?q=${Uri.encodeComponent(query)}');
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Logo (hidden on small screens)
                Expanded(
                  child: Row(
                    children: [
                      const Text(
                        'Neo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        'Movies',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE04E39),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search bar
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск фильмов и сериалов...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => _handleSearch(),
                    ),
                  ),
                ),
                
                // Right side buttons
                Row(
                  children: [
                    // Theme toggle
                    IconButton(
                      onPressed: _toggleTheme,
                      icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Settings
                    IconButton(
                      onPressed: () => context.go('/settings'),
                      icon: const Icon(Icons.settings),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // User profile or login
                    if (_userName != null) ...[
                      IconButton(
                        onPressed: () => context.go('/profile'),
                        icon: const Icon(Icons.person),
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          shape: const CircleBorder(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _userName!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE04E39),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Вход'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom navigation bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NavLink(
                    href: '/',
                    label: 'Фильмы',
                    isActive: GoRouterState.of(context).uri.path == '/',
                  ),
                  const SizedBox(width: 32),
                  _NavLink(
                    href: '/categories',
                    label: 'Категории',
                    isActive: GoRouterState.of(context).uri.path == '/categories',
                  ),
                  const SizedBox(width: 32),
                  _NavLink(
                    href: '/favorites',
                    label: 'Избранное',
                    isActive: GoRouterState.of(context).uri.path == '/favorites',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.href,
    required this.label,
    required this.isActive,
  });

  final String href;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(href),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive 
              ? const Color(0xFFE04E39) 
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}

