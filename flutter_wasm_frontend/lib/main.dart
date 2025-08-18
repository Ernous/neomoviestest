import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const WasmApp());
}

class WasmApp extends StatelessWidget {
  const WasmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(path: '/', builder: (context, state) => const _HomePage()),
        GoRoute(path: '/login', builder: (context, state) => const _SimplePage(title: 'Login')),
        GoRoute(path: '/auth', builder: (context, state) => const _SimplePage(title: 'Auth')),
        GoRoute(path: '/admin', builder: (context, state) => const _SimplePage(title: 'Admin')),
        GoRoute(path: '/settings', builder: (context, state) => const _SimplePage(title: 'Settings')),
        GoRoute(path: '/search', builder: (context, state) => const _SimplePage(title: 'Search')),
        GoRoute(path: '/favorites', builder: (context, state) => const _SimplePage(title: 'Favorites')),
        GoRoute(path: '/providers', builder: (context, state) => const _SimplePage(title: 'Providers')),
        GoRoute(path: '/profile', builder: (context, state) => const _SimplePage(title: 'Profile')),
        GoRoute(path: '/categories', builder: (context, state) => const _SimplePage(title: 'Categories')),
        GoRoute(path: '/terms', builder: (context, state) => const _SimplePage(title: 'Terms')),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) => _DetailsPage(title: 'Movie', id: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: '/tv/:id',
          builder: (context, state) => _DetailsPage(title: 'TV', id: state.pathParameters['id'] ?? ''),
        ),
      ],
      errorBuilder: (context, state) => const _SimplePage(title: 'Not Found'),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter WASM Frontend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> links = <(String, String)>[
      ('/login', 'Login'),
      ('/auth', 'Auth'),
      ('/admin', 'Admin'),
      ('/settings', 'Settings'),
      ('/search', 'Search'),
      ('/favorites', 'Favorites'),
      ('/providers', 'Providers'),
      ('/profile', 'Profile'),
      ('/categories', 'Categories'),
      ('/terms', 'Terms'),
      ('/movie/123', 'Movie: 123'),
      ('/tv/456', 'TV: 456'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const Text('Flutter WASM Frontend', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: links
                    .map((entry) => ElevatedButton(
                          onPressed: () => context.go(entry.$1),
                          child: Text(entry.$2),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimplePage extends StatelessWidget {
  const _SimplePage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage({required this.title, required this.id});

  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title • $id')),
      body: Center(
        child: Text('$title details for id: $id', style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
