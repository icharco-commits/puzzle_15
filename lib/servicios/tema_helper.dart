import 'package:flutter/material.dart';
import '../vistas/ajustes.dart';

class TemaHelper {
  /// Obtiene la decoración del fondo de pantalla según el tema seleccionado
  static BoxDecoration obtenerDecoracionFondo(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;

    if (modo == ThemeMode.light) {
      // Tema Claro (Fondo Blanco / Gris Claro)
      return const BoxDecoration(
        color: Color(0xFFF5F6FA),
      );
    } else if (modo == ThemeMode.dark) {
      // Tema Oscuro (Fondo Negro Puro)
      return const BoxDecoration(
        color: Color(0xFF121212),
      );
    } else {
      // Tema Predeterminado / Sistema (Gradiente Morado Neón Original del Juego)
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A34A4), // Morado neón brillante superior
            Color(0xFF2A1B54), // Morado profundo inferior
          ],
        ),
      );
    }
  }

  /// Obtiene el color del texto principal según el tema activo
  static Color obtenerColorTexto(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return const Color(0xFF2D3436); // Texto oscuro para fondo claro
    }
    // Texto blanco para tema Morado Predeterminado y tema Oscuro
    return Colors.white;
  }

  /// Obtiene el color de fondo para tarjetas, botones y contenedores
  static Color obtenerColorFondoTarjeta(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return Colors.white.withValues(alpha: 0.9);
    } else if (modo == ThemeMode.dark) {
      return const Color(0xFF1E1E1E);
    } else {
      // Fondo morado translúcido para el tema Predeterminado
      return const Color(0xFF382375).withValues(alpha: 0.6);
    }
  }

  /// Obtiene el color de bordes y separadores
  static Color obtenerColorBorde(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return const Color(0xFFDFE6E9);
    } else if (modo == ThemeMode.dark) {
      return const Color(0xFF333333);
    } else {
      // Borde neón sutil para el tema Predeterminado
      return const Color(0xFFFFEAA7).withValues(alpha: 0.4);
    }
  }
}