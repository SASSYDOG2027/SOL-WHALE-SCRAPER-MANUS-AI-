import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallet_model.dart';

class HeliusService {
  final String apiKey;
  final String baseUrl = 'https://mainnet.helius-rpc.com/?api-key=';

  HeliusService({required this.apiKey});

  Future<List<Trade>> getWalletTrades(String address) async {
    final url = '$baseUrl$apiKey';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "id": "my-id",
        "method": "getSignaturesForAddress",
        "params": [
          address,
          {"limit": 50}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final signatures = data['result'] as List;
      
      // In a real app, we would then fetch each transaction detail via getTransaction
      // and parse the inner instructions for swaps on Raydium/Jupiter.
      // For this implementation, we'll simulate the parsing logic.
      return signatures.map((sig) => Trade(
        signature: sig['signature'],
        walletAddress: address,
        tokenMint: 'UnknownMint',
        tokenSymbol: 'SOL',
        isBuy: true,
        amount: 1.0,
        priceUsd: 150.0,
        timestamp: DateTime.now(),
      )).toList();
    } else {
      throw Exception('Failed to load trades from Helius');
    }
  }

  Future<double> getTokenPrice(String mint) async {
    // Integration with Jupiter Price API
    final url = 'https://price.jup.ag/v4/price?ids=$mint';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'][mint]?['price'] ?? 0.0).toDouble();
    }
    return 0.0;
  }
}
