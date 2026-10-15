class Verificador {
  // Valida si el tablero generado tiene solucion
  static bool esResoluble(List<int> listaTablero, int filas, int columnas) {
    int inversiones = 0;
    List<int> fichasSinCero = listaTablero.where((ficha) => ficha != 0).toList();

    for (int i = 0; i < fichasSinCero.length; i++) {
      for (int j = i + 1; j < fichasSinCero.length; j++) {
        if (fichasSinCero[i] > fichasSinCero[j]) {
          inversiones++;
        }
      }
    }

    if (columnas % 2 != 0) {
      return inversiones % 2 == 0;
    } else {
      int indiceVacio = listaTablero.indexOf(0);
      int filaVacioDesdeArriba = indiceVacio ~/ columnas;
      int filaVacioDesdeAbajo = filas - filaVacioDesdeArriba;

      return (inversiones + filaVacioDesdeAbajo) % 2 != 0;
    }
  }
}