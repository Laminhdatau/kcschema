import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema visual KYASCHEMA — Dark mode dengan aksen neon green.
///
/// Dirancang untuk lingkungan kerja teknisi HP yang sering low-light.
/// Menggunakan warna gelap sebagai base dengan aksen neon green khas KYACODETECH.
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════
  // Warna Utama
  // ═══════════════════════════════════════════════════════════

  /// Neon green utama — warna brand KYACODETECH
  static const Color neonGreen = Color(0xFF00FF41);

  /// Variasi neon green yang lebih lembut untuk hover/secondary
  static const Color neonGreenLight = Color(0xFF39FF73);

  /// Neon green gelap untuk pressed/active state
  static const Color neonGreenDark = Color(0xFF00CC34);

  /// Neon green sangat transparan untuk glow effect
  static const Color neonGreenGlow = Color(0x3300FF41);

  // ═══════════════════════════════════════════════════════════
  // Surface Colors (Background layers)
  // ═══════════════════════════════════════════════════════════

  /// Background paling gelap (app background)
  static const Color bgDarkest = Color(0xFF0A0E17);

  /// Background panel/sidebar
  static const Color bgDark = Color(0xFF111827);

  /// Background card/elevated surface
  static const Color bgCard = Color(0xFF1A2035);

  /// Background hover state
  static const Color bgHover = Color(0xFF222B3F);

  /// Background selected/active state
  static const Color bgSelected = Color(0xFF0D2818);

  /// Border color
  static const Color borderColor = Color(0xFF2A3550);

  /// Border color aktif/fokus
  static const Color borderActive = Color(0xFF00FF41);

  // ═══════════════════════════════════════════════════════════
  // Text Colors
  // ═══════════════════════════════════════════════════════════

  /// Teks utama (heading, label penting)
  static const Color textPrimary = Color(0xFFE8ECF4);

  /// Teks sekunder (body text, deskripsi)
  static const Color textSecondary = Color(0xFF9CA3B4);

  /// Teks tersier (hint, placeholder)
  static const Color textTertiary = Color(0xFF5E6678);

  // ═══════════════════════════════════════════════════════════
  // Status Colors
  // ═══════════════════════════════════════════════════════════

  static const Color errorColor = Color(0xFFFF4757);
  static const Color warningColor = Color(0xFFFFB74D);
  static const Color successColor = Color(0xFF00FF41);
  static const Color infoColor = Color(0xFF4FC3F7);

  // ═══════════════════════════════════════════════════════════
  // Dimensi & Radius
  // ═══════════════════════════════════════════════════════════

  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // ═══════════════════════════════════════════════════════════
  // ThemeData
  // ═══════════════════════════════════════════════════════════

  /// Dark theme utama KYASCHEMA
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.inter().fontFamily,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        onPrimary: bgDarkest,
        secondary: neonGreenLight,
        onSecondary: bgDarkest,
        surface: bgDark,
        onSurface: textPrimary,
        error: errorColor,
        onError: Colors.white,
        outline: borderColor,
      ),

      // Scaffold
      scaffoldBackgroundColor: bgDarkest,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: neonGreen, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: bgDarkest,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: neonGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonGreen,
          side: const BorderSide(color: neonGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 22,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        selectedTileColor: bgSelected,
        selectedColor: neonGreen,
        textColor: textPrimary,
        iconColor: textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: bgCard,
          borderRadius: BorderRadius.circular(radiusSm),
          border: Border.all(color: borderColor),
        ),
        textStyle: const TextStyle(color: textPrimary, fontSize: 12),
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(borderColor),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(6),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: bgDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: borderColor),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: bgCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderColor),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: bgCard,
        selectedColor: bgSelected,
        side: const BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
      ),

      // Text Theme
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(color: textPrimary),
        displayMedium: textTheme.displayMedium?.copyWith(color: textPrimary),
        displaySmall: textTheme.displaySmall?.copyWith(color: textPrimary),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(color: textPrimary),
        titleSmall: textTheme.titleSmall?.copyWith(color: textSecondary),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: textSecondary),
        bodySmall: textTheme.bodySmall?.copyWith(color: textTertiary),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(color: textSecondary),
        labelSmall: textTheme.labelSmall?.copyWith(color: textTertiary),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Glassmorphism Decorations
  // ═══════════════════════════════════════════════════════════

  /// Dekorasi glassmorphism untuk panel/card
  static BoxDecoration glassDecoration({
    double borderRadius = radiusMd,
    Color? borderColorOverride,
  }) {
    return BoxDecoration(
      color: bgCard.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColorOverride ?? borderColor.withValues(alpha: 0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Dekorasi dengan neon glow effect
  static BoxDecoration neonGlowDecoration({
    double borderRadius = radiusMd,
    double glowIntensity = 0.3,
  }) {
    return BoxDecoration(
      color: bgCard,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: neonGreen.withValues(alpha: 0.5), width: 1),
      boxShadow: [
        BoxShadow(
          color: neonGreen.withValues(alpha: glowIntensity),
          blurRadius: 16,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: neonGreen.withValues(alpha: glowIntensity * 0.5),
          blurRadius: 32,
          spreadRadius: -4,
        ),
      ],
    );
  }
}
