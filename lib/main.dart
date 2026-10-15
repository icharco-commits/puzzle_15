import 'package:flutter/material.dart';
import 'modelos/tablero.dart';

void main() {
  Tablero tablero = Tablero(filas: 4, columnas: 4);
  debugPrint('Fichas iniciales: ${tablero.fichas}');

  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Tablero y Verificador funcionando')),
    ),
  ));
}