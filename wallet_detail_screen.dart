import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

class WalletDetailScreen extends StatelessWidget {
  final String address;

  const WalletDetailScreen({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(address),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share('Check out this Solana wallet: $address'),
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            const Text('PNL Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: _buildPnlChart()),
            const SizedBox(height: 24),
            const Text('Recent Trades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTradeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Total PNL', '+\$45,230', Colors.greenAccent),
                _buildSummaryStat('Win Rate', '82.4%', Colors.blueAccent),
              ],
            ),
            const Divider(height: 32, color: Color(0xFF30363D)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('Avg Hold', '4.2h', Colors.orangeAccent),
                _buildSummaryStat('Trade Count', '142', Colors.purpleAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildPnlChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 1.5),
              FlSpot(2, 1.2),
              FlSpot(3, 2.5),
              FlSpot(4, 2.2),
              FlSpot(5, 3.8),
            ],
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.greenAccent.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: index % 2 == 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            child: Icon(
              index % 2 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: index % 2 == 0 ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          title: const Text('Bought 2.4 SOL of \$WIF'),
          subtitle: const Text('2 hours ago'),
          trailing: const Text('+\$420', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
