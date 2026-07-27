import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/app_database.dart';
import 'core/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database (auto-create + seed kategori default)
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        // Override database provider dengan instance yang sudah dibuat
        databaseProvider.overrideWithValue(database),
      ],
      child: const KyaSchemaApp(),
    ),
  );
}
