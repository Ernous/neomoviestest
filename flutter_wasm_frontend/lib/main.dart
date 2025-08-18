import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_wasm_frontend/pages/home_page.dart';
import 'package:flutter_wasm_frontend/pages/search_page.dart';
import 'package:flutter_wasm_frontend/pages/movie_detail_page.dart';
import 'package:flutter_wasm_frontend/pages/login_page.dart';
import 'package:flutter_wasm_frontend/pages/favorites_page.dart';
import 'package:flutter_wasm_frontend/pages/settings_page.dart';

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
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(path: '/auth', builder: (context, state) => const _SimplePage(title: 'Auth')),
        GoRoute(path: '/admin', builder: (context, state) => const _SimplePage(title: 'Admin')),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
        GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
        GoRoute(path: '/favorites', builder: (context, state) => const _SimplePage(title: 'Favorites')),
        GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPage()),
        GoRoute(path: '/providers', builder: (context, state) => const _SimplePage(title: 'Providers')),
        GoRoute(path: '/profile', builder: (context, state) => const _SimplePage(title: 'Profile')),
        GoRoute(path: '/categories', builder: (context, state) => const _SimplePage(title: 'Categories')),
        GoRoute(path: '/terms', builder: (context, state) => const _SimplePage(title: 'Terms')),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) => MovieDetailPage(id: state.pathParameters['id'] ?? ''),
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE04E39)),
        useMaterial3: true,
      ),
      routerConfig: router,
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
