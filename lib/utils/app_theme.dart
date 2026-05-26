// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTheme {
  AppTheme._();

  // Colors - Light Fresh Theme
  static const Color primary = Color(0xFFEFF6FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFF8FAFF);
  static const Color accent = Color(0xFF3B82F6);
  static const Color danger = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color critical = Color(0xFFF97316);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: primary,
        colorScheme: const ColorScheme.light(
          primary: accent,
          surface: surface,
          onPrimary: Colors.white,
          onSurface: textPrimary,
          error: danger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: divider, width: 1),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),
          hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
          prefixIconColor: textSecondary,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          indicatorColor: accent.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
}

class AppFormatters {
  AppFormatters._();

  static final _compact = NumberFormat.compact();
  static final _full = NumberFormat('#,###');
  static final _dateFormat = DateFormat('MMM dd, yyyy HH:mm');

  static String compact(int number) => _compact.format(number);
  static String full(int number) => _full.format(number);

  static String formatDate(int timestampMs) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    return _dateFormat.format(date);
  }

  static String percentOf(int part, int total) {
    if (total == 0) return '0.0%';
    return '${(part / total * 100).toStringAsFixed(1)}%';
  }
}
