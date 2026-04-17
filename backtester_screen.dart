import 'package:flutter/material.dart';

class BacktesterScreen extends StatefulWidget {
  const BacktesterScreen({super.key});

  @override
  State<BacktesterScreen> createState() => _BacktesterScreenState();
}

class _BacktesterScreenState extends State<BacktesterScreen> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController(text: '1.0');
  bool _isAnalyzing = false;

  void _runSimulation() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isAnalyzing = false);
    if (mounted) {
      _showResult();
    }
  }

  void _showResult() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161B22),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Simulation Result', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildResultRow('Total Trades', '142'),
            _buildResultRow('Simulated Profit', '+14.2 SOL', Colors.greenAccent),
            _buildResultRow('Win Rate', '82.4%'),
            _buildResultRow('Max Drawdown', '-1.2 SOL', Colors.redAccent),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PNL Simulator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Test a wallet strategy by simulating trades with a custom position size.', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Wallet Address',
                hintText: 'Paste Solana wallet address',
                filled: true,
                fillColor: const Color(0xFF161B22),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF30363D))),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Position Size (SOL)',
                hintText: 'Enter SOL amount per trade',
                filled: true,
                fillColor: const Color(0xFF161B22),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF30363D))),
                prefixIcon: const Icon(Icons.attach_money, color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _runSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isAnalyzing ? const CircularProgressIndicator(color: Colors.black) : const Text('Run Backtest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
