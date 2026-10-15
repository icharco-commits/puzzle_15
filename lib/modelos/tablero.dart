import 'dart:math';
import '../logica/verificador.dart';

class Tablero {
  final int filas;
  final int columnas;
  late List<int> fichas;
  int indiceVacio = 0;
  int contadorMovimientos = 0;

  Tablero({required this.filas, required this.columnas}) {
    reiniciarTablero();
  }

  int get totalFichas => filas * columnas;

  // Genera un tablero aleatorio resoluble
  void reiniciarTablero() {
    contadorMovimientos = 0;
    List<int> inicial = List.generate(totalFichas, (i) => (i + 1) % totalFichas);

    do {
      inicial.shuffle(Random());
    } while (!Verificador.esResoluble(inicial, filas, columnas) || esListaResuelta(inicial));

    fichas = inicial;
    indiceVacio = fichas.indexOf(0);
  }

  // Evalua si el juego finalizo
  bool verificarVictoria() {
    return esListaResuelta(fichas);
  }

  bool esListaResuelta(List<int> lista) {
    for (int i = 0; i < lista.length - 1; i++) {
      if (lista[i] != i + 1) return false;
    }
    return lista.last == 0;
  }

  // Mueve la ficha si esta junta al vacio
  bool moverFicha(int indiceFicha) {
    if (!esAdyacente(indiceFicha, indiceVacio)) return false;

    fichas[indiceVacio] = fichas[indiceFicha];
    fichas[indiceFicha] = 0;
    indiceVacio = indiceFicha;
    contadorMovimientos++;
    return true;
  }

  // Revisa adyacencia
  bool esAdyacente(int indice1, int indice2) {
    int fila1 = indice1 ~/ columnas;
    int columna1 = indice1 % columnas;
    int fila2 = indice2 ~/ columnas;
    int columna2 = indice2 % columnas;

    bool mismaFila = (fila1 == fila2) && ((columna1 - columna2).abs() == 1);
    bool mismaColumna = (columna1 == columna2) && ((fila1 - fila2).abs() == 1);

    return mismaFila || mismaColumna;
  }
}