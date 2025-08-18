import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _player = 'alloha';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _player = prefs.getString('defaultPlayer') ?? 'alloha');
  }

  Future<void> _setPlayer(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultPlayer', value);
    setState(() => _player = value);
  }

  @override
  Widget build(BuildContext context) {
    final List<({String id, String name, String description})> players = const [
      (id: 'alloha', name: 'Alloha', description: 'Основной плеер с высоким качеством и быстрой загрузкой.'),
      (id: 'lumex', name: 'Lumex', description: 'Альтернативный плеер, может быть полезен при проблемах с основным.'),
      (id: 'vibix', name: 'Vibix', description: 'Современный плеер с адаптивным качеством и стабильной работой.'),
    ];

    return Scaffold(
      appBar: const HeaderBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2D2D) : const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x22000000))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Настройки плеера', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Выберите плеер, который будет использоваться по умолчанию для просмотра.',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  const SizedBox(height: 16),
                  ...players.map((p) => InkWell(
                        onTap: () => _setPlayer(p.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _player == p.id ? const Color(0x1AE04E39) : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2D2D2D) : Colors.white),
                            border: Border.all(color: _player == p.id ? const Color(0xFFE04E39) : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF8B5E3C) : const Color(0xFFE5D3BE)), width: 2),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(p.description, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                          ]),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

