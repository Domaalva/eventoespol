import 'package:flutter/material.dart';

/// Tema visual compartido de EventoESPOL — modo oscuro navy con acentos
/// naranjas y detalles editoriales (tipografía serif para títulos grandes).
///
/// Esto es infraestructura compartida (como database.py en el backend):
/// define colores, tipografía y estilos de componentes que Flutter aplica
/// automáticamente a TODAS las pantallas, sin que cada integrante tenga
/// que repetir el mismo código de estilos en su propia vista.
class AppTheme {
  static const Color backgroundStart = Color(0xFF0A1122);
  static const Color backgroundEnd = Color(0xFF16213E);
  static const Color surfaceCard = Color(0xFF1C2745);
  static const Color surfaceCardLight = Color(0xFF25335A);
  static const Color accent = Color(0xFFF5A83A);
  static const Color accentSoft = Color(0xFFFFC876);
  static const Color success = Color(0xFF4CAF6D);
  static const Color danger = Color(0xFFE07A6B);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB6C0DA);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  static const LinearGradient accentGradient = LinearGradient(colors: [accent, accentSoft]);

  static const Map<String, Color> categoriaColor = {
    "Tecnologia": Color(0xFFF5A83A),
    "Tecnología": Color(0xFFF5A83A),
    "Cultura": Color(0xFFCB8CE8),
    "Deportes": Color(0xFF4CAF6D),
  };

  static Color colorParaCategoria(String categoria) => categoriaColor[categoria] ?? accent;

  /// Fuente serif para titulares grandes (look editorial). Usa la familia
  /// genérica "serif", que el navegador/SO resuelve a una tipografía con
  /// remates disponible en el sistema, sin depender de paquetes externos.
  static const String displayFont = "serif";

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
        primary: accent,
        secondary: accentSoft,
        surface: surfaceCard,
        error: danger,
      ),
      scaffoldBackgroundColor: backgroundStart,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: textPrimary,
          height: 1.05,
        ),
        headlineSmall: const TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.1,
        ),
        titleLarge: const TextStyle(fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: const TextStyle(fontWeight: FontWeight.w700, color: textPrimary),
        bodyMedium: const TextStyle(height: 1.35, color: textSecondary),
        labelLarge: const TextStyle(fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceCard,
        selectedColor: Colors.white,
        labelStyle: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 12.5),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: const Color(0xFF1C2745),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Color(0xFF1C2745),
        elevation: 2,
        extendedTextStyle: TextStyle(fontWeight: FontWeight.w800),
        shape: StadiumBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: accent,
        elevation: 6,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? const Color(0xFF1C2745) : Colors.grey.shade500);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF1C2745) : Colors.grey.shade500,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCardLight,
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
        contentTextStyle: const TextStyle(color: textSecondary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceCardLight,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Fondo con degradado navy, para envolver el body de cada pantalla.
/// Uso: Scaffold(backgroundColor: Colors.transparent, body: AppBackground(child: ...))
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: child,
    );
  }
}

/// Etiqueta "eyebrow" pequeña en mayúsculas, con borde naranja sutil.
class EyebrowLabel extends StatelessWidget {
  final String text;
  const EyebrowLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.accent,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Widget reutilizable para estados vacíos (nada que mostrar todavía).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String? subtitulo;

  const EmptyState({super.key, required this.icon, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: AppTheme.surfaceCard, shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: AppTheme.accent),
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitulo!,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
