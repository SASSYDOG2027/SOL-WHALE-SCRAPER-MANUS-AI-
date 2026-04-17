import 'dart:convert';

class Wallet {
  final String address;
  final String? name;
  final double totalPnlUsd;
  final double winRate;
  final int totalTrades;
  final double roi;
  final DateTime lastActivity;
  final double copyScore;
  final bool isWatchlisted;

  Wallet({
    required this.address,
    this.name,
    this.totalPnlUsd = 0.0,
    this.winRate = 0.0,
    this.totalTrades = 0,
    this.roi = 0.0,
    required this.lastActivity,
    this.copyScore = 0.0,
    this.isWatchlisted = false,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['address'],
      name: json['name'],
      totalPnlUsd: (json['totalPnlUsd'] ?? 0.0).toDouble(),
      winRate: (json['winRate'] ?? 0.0).toDouble(),
      totalTrades: json['totalTrades'] ?? 0,
      roi: (json['roi'] ?? 0.0).toDouble(),
      lastActivity: DateTime.parse(json['lastActivity']),
      copyScore: (json['copyScore'] ?? 0.0).toDouble(),
      isWatchlisted: json['isWatchlisted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'totalPnlUsd': totalPnlUsd,
      'winRate': winRate,
      'totalTrades': totalTrades,
      'roi': roi,
      'lastActivity': lastActivity.toIso8601String(),
      'copyScore': copyScore,
      'isWatchlisted': isWatchlisted,
    };
  }

  Wallet copyWith({
    String? name,
    double? totalPnlUsd,
    double? winRate,
    int? totalTrades,
    double? roi,
    DateTime? lastActivity,
    double? copyScore,
    bool? isWatchlisted,
  }) {
    return Wallet(
      address: this.address,
      name: name ?? this.name,
      totalPnlUsd: totalPnlUsd ?? this.totalPnlUsd,
      winRate: winRate ?? this.winRate,
      totalTrades: totalTrades ?? this.totalTrades,
      roi: roi ?? this.roi,
      lastActivity: lastActivity ?? this.lastActivity,
      copyScore: copyScore ?? this.copyScore,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
    );
  }
}

class Trade {
  final String signature;
  final String walletAddress;
  final String tokenMint;
  final String tokenSymbol;
  final bool isBuy;
  final double amount;
  final double priceUsd;
  final DateTime timestamp;
  final double? pnlUsd;

  Trade({
    required this.signature,
    required this.walletAddress,
    required this.tokenMint,
    required this.tokenSymbol,
    required this.isBuy,
    required this.amount,
    required this.priceUsd,
    required this.timestamp,
    this.pnlUsd,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      signature: json['signature'],
      walletAddress: json['walletAddress'],
      tokenMint: json['tokenMint'],
      tokenSymbol: json['tokenSymbol'],
      isBuy: json['isBuy'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      priceUsd: (json['priceUsd'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      pnlUsd: json['pnlUsd']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signature': signature,
      'walletAddress': walletAddress,
      'tokenMint': tokenMint,
      'tokenSymbol': tokenSymbol,
      'isBuy': isBuy,
      'amount': amount,
      'priceUsd': priceUsd,
      'timestamp': timestamp.toIso8601String(),
      'pnlUsd': pnlUsd,
    };
  }
}
