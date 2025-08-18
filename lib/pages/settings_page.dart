import 'package:flutter/material.dart';
import 'package:flutter_wasm_frontend/widgets/header_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedPlayer = 'alloha';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPlayer = prefs.getString('defaultPlayer') ?? 'alloha';
      _loading = false;
    });
  }

  Future<void> _savePlayer(String player) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultPlayer', player);
    setState(() => _selectedPlayer = player);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Плеер изменен на: $player')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderBar(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Настройки',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Плеер по умолчанию',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Выберите плеер, который будет использоваться для воспроизведения фильмов и сериалов',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                _PlayerOption(
                                  title: 'Alloha',
                                  subtitle: 'Основной плеер',
                                  value: 'alloha',
                                  groupValue: _selectedPlayer,
                                  onChanged: _savePlayer,
                                ),
                                const SizedBox(height: 8),
                                
                                _PlayerOption(
                                  title: 'Lumex',
                                  subtitle: 'Альтернативный плеер',
                                  value: 'lumex',
                                  groupValue: _selectedPlayer,
                                  onChanged: _savePlayer,
                                ),
                                const SizedBox(height: 8),
                                
                                _PlayerOption(
                                  title: 'Vibix',
                                  subtitle: 'Резервный плеер',
                                  value: 'vibix',
                                  groupValue: _selectedPlayer,
                                  onChanged: _savePlayer,
                                ),
                              ],
                            ),
                          ),
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

class _PlayerOption extends StatelessWidget {
  const _PlayerOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}

