import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database_service.g.dart';

class Wallets extends Table {
  TextColumn get address => text().withLength(min: 32, max: 44)();
  TextColumn get name => text().nullable()();
  RealColumn get totalPnlUsd => real().withDefault(const Constant(0.0))();
  RealColumn get winRate => real().withDefault(const Constant(0.0))();
  IntColumn get totalTrades => integer().withDefault(const Constant(0))();
  RealColumn get roi => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastActivity => dateTime()();
  RealColumn get copyScore => real().withDefault(const Constant(0.0))();
  BoolColumn get isWatchlisted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {address};
}

class Trades extends Table {
  TextColumn get signature => text()();
  TextColumn get walletAddress => text().references(Wallets, #address)();
  TextColumn get tokenMint => text()();
  TextColumn get tokenSymbol => text()();
  BoolColumn get isBuy => boolean()();
  RealColumn get amount => real()();
  RealColumn get priceUsd => real()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get pnlUsd => real().nullable()();

  @override
  Set<Column> get primaryKey => {signature};
}

@DriftDatabase(tables: [Wallets, Trades])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Wallet queries
  Future<List<Wallet>> getAllWallets() => select(wallets).get();
  Future<int> insertWallet(WalletsCompanion wallet) => into(wallets).insertOnConflictUpdate(wallet);
  Future<List<Wallet>> getWatchlistedWallets() => (select(wallets)..where((t) => t.isWatchlisted.equals(true))).get();
  
  // Trade queries
  Future<List<Trade>> getTradesForWallet(String address) => (select(trades)..where((t) => t.walletAddress.equals(address))).get();
  Future<int> insertTrade(TradesCompanion trade) => into(trades).insertOnConflictUpdate(trade);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
