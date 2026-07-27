import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

/// Provider global untuk instance database KYASCHEMA.
/// Diinisialisasi di main.dart dan digunakan di seluruh aplikasi.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
