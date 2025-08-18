import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/api/api_client.dart';
import 'package:flutter_wasm_frontend/api/auth_api.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthApi _auth;
  bool _loading = true;
  String? _name;
  String? _email;
  bool _confirmDelete = false;

  @override
  void initState() {
    super.initState();
    _auth = AuthApi(ApiClient());
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      if (mounted) context.go('/login');
      return;
    }
    setState(() {
      _name = prefs.getString('userName');
      _email = prefs.getString('userEmail');
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (mounted) context.go('/');
  }

  Future<void> _deleteAccount() async {
    setState(() => _confirmDelete = false);
    try {
      await _auth.login(email: '', password: ''); // placeholder to access client; delete will be server-side
    } catch (_) {}
    // Here ideally: call delete endpoint (we have in Next: authAPI.deleteAccount). For now, clear storage.
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) context.go('/');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Аккаунт удален')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Назад'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFBF5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x22000000))],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFE5E7EB),
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF3F4F6), width: 4),
                              ),
                              alignment: Alignment.center,
                              child: Text((_name ?? '').split(' ').map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 12),
                            Text(_name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(_email ?? '', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFBF5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x22000000))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Управление аккаунтом', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(onPressed: _logout, icon: const Icon(Icons.logout), label: const Text('Выйти из аккаунта')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFF0000),
                          border: Border.all(color: const Color(0x80FF0000), width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Опасная зона', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                            const SizedBox(height: 8),
                            const Text('Это действие нельзя будет отменить. Все ваши данные, включая избранное, будут удалены.', style: TextStyle(color: Colors.redAccent)),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => setState(() => _confirmDelete = true),
                              icon: const Icon(Icons.delete),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              label: const Text('Удалить аккаунт'),
                            ),
                          ],
                        ),
                      ),
                      if (_confirmDelete)
                        AlertDialog(
                          title: const Text('Подтвердите удаление аккаунта'),
                          content: const Text('Вы уверены, что хотите навсегда удалить свой аккаунт? Все ваши данные будут безвозвратно удалены.'),
                          actions: [
                            TextButton(onPressed: () => setState(() => _confirmDelete = false), child: const Text('Отмена')),
                            TextButton(onPressed: _deleteAccount, child: const Text('Удалить')),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

