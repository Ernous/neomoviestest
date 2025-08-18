import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _checkTermsStatus();
  }

  Future<void> _checkTermsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accepted = prefs.getBool('termsAccepted') ?? false;
    });
  }

  Future<void> _acceptTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAccepted', true);
    setState(() => _accepted = true);
    
    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _declineTerms() async {
    // Clear all stored data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_accepted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const HeaderBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Пользовательское соглашение',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Условия использования NeoMovies',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              const Text(
                                'Добро пожаловать в NeoMovies! Пользуясь нашим сервисом, вы соглашаетесь со следующими условиями:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              
                              const Text(
                                '1. Возрастные ограничения\n'
                                'Вы должны быть старше 18 лет для использования сервиса.',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              
                              const Text(
                                '2. Контент\n'
                                'Весь контент предоставляется "как есть" без каких-либо гарантий.',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              
                              const Text(
                                '3. Авторские права\n'
                                'Мы уважаем права интеллектуальной собственности и просим вас делать то же самое.',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              
                              const Text(
                                '4. Ответственность\n'
                                'NeoMovies не несет ответственности за действия пользователей.',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              
                              const Text(
                                '5. Изменения\n'
                                'Мы оставляем за собой право изменять эти условия в любое время.',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              
                              const Text(
                                'Продолжая использование сервиса, вы подтверждаете, что прочитали и согласны с данными условиями.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _declineTerms,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Отклонить'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _acceptTerms,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE04E39),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Принять'),
                        ),
                      ),
                    ],
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

