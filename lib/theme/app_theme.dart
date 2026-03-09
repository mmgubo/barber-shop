import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Static accent colors (same in both themes) ─────────────────
class AppTheme {
  static const Color primary = Color(0xFFD4AF37);
  static const Color primaryDark = Color(0xFFB8860B);
  static const Color success = Color(0xFF4CAF50);

  static ThemeData get darkTheme => _build(AppColors._dark);
  static ThemeData get lightTheme => _build(AppColors._light);

  static ThemeData _build(AppColors c) {
    final isDark = c.background.computeLuminance() < 0.5;
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: Colors.black,
        secondary: primary,
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: c.surface,
        onSurface: c.textPrimary,
      ),
      extensions: [c],
      scaffoldBackgroundColor: c.background,
      textTheme: GoogleFonts.latoTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: primary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: primary),
        systemOverlayStyle: isDark
            ? const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              )
            : const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: primary,
        unselectedItemColor: c.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      cardTheme: CardTheme(
        color: c.card,
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary),
        ),
        hintStyle: TextStyle(color: c.textSecondary),
        prefixIconColor: c.textSecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: primary,
        labelStyle: TextStyle(color: c.textSecondary),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
      dividerColor: c.divider,
      dividerTheme: DividerThemeData(color: c.divider),
    );
  }
}

// ── Dynamic colors via ThemeExtension ──────────────────────────
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;

  const AppColors({
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
  });

  static const AppColors _dark = AppColors(
    background: Color(0xFF111111),
    surface: Color(0xFF1C1C1C),
    card: Color(0xFF242424),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9E9E9E),
    divider: Color(0xFF2E2E2E),
  );

  static const AppColors _light = AppColors(
    background: Color(0xFFF7F3ED),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFAF7F2),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B6B6B),
    divider: Color(0xFFE8E0D5),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
  }) =>
      AppColors(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        card: card ?? this.card,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        divider: divider ?? this.divider,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

// ── Convenience shorthand ───────────────────────────────────────
extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
