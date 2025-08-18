import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFBF5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x22000000))],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Пользовательское соглашение Neo Movies', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Пожалуйста, внимательно ознакомьтесь с условиями использования', style: TextStyle(color: Color(0xFF9CA3AF))),
                      SizedBox(height: 16),
                      // Для краткости: здесь можно перенести весь текст из Next.js
                      Text('Благодарим вас за интерес к сервису Neo Movies. Пожалуйста, ознакомьтесь с нашими условиями использования перед началом работы.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                  ),
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // decline
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вы не можете использовать сайт без согласия с условиями.')));
                        },
                        child: const Text('Отклонить'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // accept
                          // In web we could store localStorage via JS, but for now route home
                          context.go('/');
                        },
                        child: const Text('Принимаю условия'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('© 2025 Neo Movies. Все права защищены.', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

