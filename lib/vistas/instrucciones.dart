import 'package:flutter/material.dart';
import '../servicios/tema_helper.dart';
import 'ajustes.dart';

class InstruccionesView extends StatelessWidget {
  const InstruccionesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AjustesView.modoTemaNotifier,
      builder: (context, _, __) {
        final colorTexto = TemaHelper.obtenerColorTexto(context);
        final colorTarjeta = TemaHelper.obtenerColorFondoTarjeta(context);
        final colorBorde = TemaHelper.obtenerColorBorde(context);

        return Container(
          decoration: TemaHelper.obtenerDecoracionFondo(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: colorTexto),
              title: Text(
                'Instrucciones',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
              ),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorBorde, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¿Cómo jugar al 15 Puzzle?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFEAA7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '1. Objetivo del juego:\n'
                            'Ordena todas las fichas en orden numérico ascendente (1, 2, 3...) de izquierda a derecha y de arriba a abajo, dejando la casilla vacía en la última posición.\n\n'
                            '2. Movimiento de fichas:\n'
                            'Toca cualquier ficha que esté directamente al lado (arriba, abajo, izquierda o derecha) de la casilla vacía para moverla hacia ese espacio.\n\n'
                            '3. Límites de movimientos:\n'
                            '• Fácil (3x3): Máximo 300 movimientos.\n'
                            '• Medio (4x4): Máximo 500 movimientos.\n'
                            '• Difícil (5x5): Máximo 700 movimientos.\n\n'
                            '4. Puntuaciones y Récords:\n'
                            'Tus mejores marcas en tiempo y movimientos se guardarán automáticamente en la sección de Puntuaciones.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: colorTexto.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}