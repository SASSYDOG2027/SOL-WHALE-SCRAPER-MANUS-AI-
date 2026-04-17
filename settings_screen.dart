import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _heliusKeyController = TextEditingController();
  double _minWinRate = 65.0;
  int _minTrades = 20;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _heliusKeyController.text = prefs.getString('helius_api_key') ?? '';
      _minWinRate = prefs.getDouble('min_win_rate') ?? 65.0;
      _minTrades = prefs.getInt('min_trades') ?? 20;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('helius_api_key', _heliusKeyController.text);
    await prefs.setDouble('min_win_rate', _minWinRate);
    await prefs.setInt('min_trades', _minTrades);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('Save', style: TextStyle(color: Colors.greenAccent))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('API Configuration'),
          _buildHeliusInput(),
          const SizedBox(height: 24),
          _buildSectionHeader('Ranking Filters'),
          _buildSliderSetting('Min Win Rate', '${_minWinRate.toInt()}%', _minWinRate, 0, 100, (val) {
            setState(() => _minWinRate = val);
          }),
          _buildSliderSetting('Min Trades', _minTrades.toString(), _minTrades.toDouble(), 0, 100, (val) {
            setState(() => _minTrades = val.toInt());
          }),
          const SizedBox(height: 24),
          _buildSectionHeader('App Preferences'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Alert when high-score wallets trade'),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            activeColor: Colors.greenAccent,
          ),
          const Divider(height: 32, color: Color(0xFF30363D)),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('Version'),
            trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildHeliusInput() {
    return TextField(
      controller: _heliusKeyController,
      decoration: InputDecoration(
        labelText: 'Helius API Key',
        hintText: 'Enter your Helius API Key',
        filled: true,
        fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF30363D))),
        prefixIcon: const Icon(Icons.vpn_key_outlined, color: Colors.greenAccent),
      ),
    );
  }

  Widget _buildSliderSetting(String label, String value, double current, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
          ],
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.greenAccent,
          inactiveColor: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}
