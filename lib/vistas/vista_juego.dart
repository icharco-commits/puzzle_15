import 'dart:async';
import 'package:flutter/material.dart';
import '../modelos/tablero.dart';
import '../servicios/almacenamiento.dart';

class VistaJuego extends StatefulWidget {
  const VistaJuego({super.key});

  @override
  State<VistaJuego> createState() => _VistaJuegoState();
}

class _VistaJuegoState extends State<VistaJuego> {
  late Tablero _tablero;
  int _segundos = 0;
  Timer? _timer;
  String _dificultadSeleccionada = 'medio';
  bool _enJuego = false;

  void _iniciarPartida(String dificultad) {
    int filas = 4;
    int columnas = 4;

    if (dificultad == 'facil') {
      filas = 3;
      columnas = 3;
    } else if (dificultad == 'dificil') {
      filas = 5;
      columnas = 5;
    }

    setState(() {
      _dificultadSeleccionada = dificultad;
      _tablero = Tablero(filas: filas, columnas: columnas);
      _enJuego = true;
    });

    _reiniciarCronometro();
  }

  void _reiniciarCronometro() {
    _timer?.cancel();
    _segundos = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() => _segundos++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onFichaTap(int index) async {
    bool movido = _tablero.moverFicha(index);
    if (movido) {
      setState(() {});
      if (_tablero.verificarVictoria()) {
        _timer?.cancel();
        
        final nuevoPuntaje = EntradaPuntaje(
          tiempoSegundos: _segundos,
          movimientos: _tablero.contadorMovimientos,
          fecha: DateTime.now().toString().split(' ')[0],
        );
        await Almacenamiento.guardarPuntaje(_dificultadSeleccionada, nuevoPuntaje);

        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('¡Felicidades! 🎉'),
            content: Text(
              '¡Completaste el puzzle!\n\n'
              'Movimientos: ${_tablero.contadorMovimientos}\n'
              'Tiempo: $_segundos segundos',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _enJuego = false; // Vuelve a la pantalla de selección de cuadros
                  });
                },
                child: const Text('Elegir otra dificultad'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si aún no ha elegido dificultad, mostramos tus cuadritos de selección originales
    if (!_enJuego) {
      return Scaffold(
        appBar: AppBar(title: const Text('Seleccionar Dificultad')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cuadritoDificultad(
                  titulo: 'Fácil (3x3)',
                  color: Colors.green,
                  onTap: () => _iniciarPartida('facil'),
                ),
                const SizedBox(height: 16),
                _cuadritoDificultad(
                  titulo: 'Medio (4x4)',
                  color: Colors.blueAccent,
                  onTap: () => _iniciarPartida('medio'),
                ),
                const SizedBox(height: 16),
                _cuadritoDificultad(
                  titulo: 'Difícil (5x5)',
                  color: Colors.redAccent,
                  onTap: () => _iniciarPartida('dificil'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Pantalla activa del tablero de juego
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle (${_dificultadSeleccionada.toUpperCase()})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _timer?.cancel();
            setState(() => _enJuego = false);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _tablero.reiniciarTablero();
                _reiniciarCronometro();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Movimientos: ${_tablero.contadorMovimientos}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Tiempo: ${_segundos}s',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _tablero.columnas,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _tablero.totalFichas,
                itemBuilder: (context, index) {
                  int numero = _tablero.fichas[index];
                  if (numero == 0) {
                    return const SizedBox.shrink();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _onFichaTap(index),
                    child: Text(
                      '$numero',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cuadritoDificultad({required String titulo, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.2),
          foregroundColor: Colors.white,
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          titulo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}