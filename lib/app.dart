import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

/// Root widget aplikasi KYASCHEMA.
///
/// Menggunakan MaterialApp.router dengan GoRouter untuk navigasi
/// dan tema dark mode KYACODETECH.
class KyaSchemaApp extends StatelessWidget {
  const KyaSchemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KYASCHEMA - Schematic Manager',
      debugShowCheckedModeBanner: false,

      // Tema dark mode KYACODETECH
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Router
      routerConfig: AppRouter.router,
    );
  }
}
