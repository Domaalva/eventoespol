import 'package:flutter/material.dart';

/// Tema visual compartido de EventoESPOL.
///
/// Esto es infraestructura compartida (como database.py en el backend):
/// define colores, tipografía y estilos de componentes que Flutter aplica
/// automáticamente a TODAS las pantallas, sin que cada integrante tenga
/// que repetir el mismo código de estilos en su propia vista.
class AppTheme {
  // Paleta: azul institucional profundo + acento cálido (ámbar), sobre un
  // fondo gris-azulado muy claro (no blanco puro, para que las tarjetas
  // resalten con su propia sombra).
  static const Color primary = Color(0xFF1F3864); // azul ESPOL
  static const Color primaryLight = Color(0xFF3A5A8C);
  static const Color accent = Color(0xFFE8A33D); // ámbar cálido
  static const Color background = Color(0xFFF3F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFC0392B);

  // Colores por categoría de evento, para que el ojo distinga de un
  // vistazo el tipo de evento sin tener que leer la etiqueta.
  static const Map<String, Color> categoriaColor = {
    "Tecnologia": Color(0xFF2C6E9B),
    "Tecnología": Color(0xFF2C6E9B),
    "Cultura": Color(0xFF8E4585),
    "Deportes": Color(0xFF2E7D32),
  };

  static Color colorParaCategoria(String categoria) =>
      categoriaColor[categoria] ?? primaryLight;

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      scaffoldBackgroundColor: background,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: primary,
        ),
        titleLarge: const TextStyle(fontWeight: FontWeight.w700),
        titleMedium: const TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: const TextStyle(height: 1.35),
        labelLarge: const TextStyle(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: primary.withOpacity(0.08),
        labelStyle: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: primary,
        elevation: 2,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accent.withOpacity(0.25),
        elevation: 3,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Widget reutilizable para estados vacíos (nada que mostrar todavía).
/// Cualquier pantalla puede usarlo para verse más cuidada sin más trabajo.
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
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitulo!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
