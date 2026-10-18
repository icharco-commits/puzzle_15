import 'package:flutter/material.dart';
import '../vistas/ajustes.dart';

class TemaHelper {
  // Retorna la decoración del fondo según el modo seleccionado
  static BoxDecoration obtenerDecoracionFondo(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;

    if (modo == ThemeMode.light) {
      return const BoxDecoration(
        color: Color(0xFFF5F6FA), // Fondo Blanco / Gris claro
      );
    } else if (modo == ThemeMode.dark) {
      return const BoxDecoration(
        color: Color(0xFF121212), // Fondo Negro Oscuro puro
      );
    } else {
      // Predeterminado / Sistema: Gradiente Morado Neón Original
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B2874),
            Color(0xFF6C5CE7),
            Color(0xFF2A1B54),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
  }

  // Color de texto principal según tema
  static Color obtenerColorTexto(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return const Color(0xFF2D3436); // Texto oscuro
    }
    return Colors.white; // Texto blanco
  }

  // Color de texto secundario
  static Color obtenerColorTextoSecundario(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return const Color(0xFF636E72);
    }
    return Colors.white70;
  }

  // Color de fondo para las tarjetas/contenedores
  static Color obtenerColorFondoTarjeta(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return Colors.black.withOpacity(0.05);
    } else if (modo == ThemeMode.dark) {
      return Colors.white.withOpacity(0.08);
    }
    return Colors.white.withOpacity(0.12); // Morado original
  }

  // Color de bordes
  static Color obtenerColorBorde(BuildContext context) {
    final modo = AjustesView.modoTemaNotifier.value;
    if (modo == ThemeMode.light) {
      return Colors.black12;
    }
    return Colors.white.withOpacity(0.2);
  }
}