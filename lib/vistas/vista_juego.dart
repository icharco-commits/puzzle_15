import 'dart:async';
import 'package:flutter/material.dart';
import '../modelos/tablero.dart';
import '../servicios/almacenamiento.dart';
import '../servicios/servicio_audio.dart';
import '../servicios/tema_helper.dart';
import 'ajustes.dart';

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
  int _limiteMovimientos = 500;
  bool _primerMovimientoHecho = false;

  void _iniciarPartida(String dificultad) {
    int filas = 4;
    int columnas = 4;
    int limite = 500;

    if (dificultad == 'facil') {
      filas = 3;
      columnas = 3;
      limite = 300;
    } else if (dificultad == 'medio') {
      filas = 4;
      columnas = 4;
      limite = 500;
    } else if (dificultad == 'dificil') {
      filas = 5;
      columnas = 5;
      limite = 700;
    }

    _timer?.cancel();

    setState(() {
      _dificultadSeleccionada = dificultad;
      _limiteMovimientos = limite;
      _tablero = Tablero(filas: filas, columnas: columnas);
      _segundos = 0;
      _primerMovimientoHecho = false;
      _enJuego = true;
    });
  }

  void _iniciarCronometro() {
    _timer?.cancel();
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

  Color _obtenerColorPieza(int numero) {
    if (AjustesView.estiloPiezasNotifier.value == 'Colorido') {
      final coloresNeon = [
        const Color(0xFF55EFC4),
        const Color(0xFFFFEAA7),
        const Color(0xFFFF7675),
        const Color(0xFF74B9FF),
        const Color(0xFFA29BFE),
        const Color(0xFFFD79A8),
      ];
      return coloresNeon[numero % coloresNeon.length];
    }
    return const Color(0xFFFFEAA7);
  }

  void _onFichaTap(int index) async {
    bool movido = _tablero.moverFicha(index);
    if (movido) {
      if (!_primerMovimientoHecho) {
        _primerMovimientoHecho = true;
        _iniciarCronometro();
      }

      ServicioAudio.reproducirMoverFicha();
      setState(() {});

      if (_tablero.verificarVictoria()) {
        _timer?.cancel();
        ServicioAudio.reproducirVictoria();

        bool esNuevoRecord = false;
        try {
          final marcasAnteriores = await Almacenamiento.obtenerPuntajes(_dificultadSeleccionada);
          if (marcasAnteriores.isEmpty || _tablero.contadorMovimientos <= marcasAnteriores.first.movimientos) {
            esNuevoRecord = true;
          }

          final nuevoPuntaje = EntradaPuntaje(
            tiempoSegundos: _segundos,
            movimientos: _tablero.contadorMovimientos,
            fecha: DateTime.now().toString().split(' ')[0],
          );
          await Almacenamiento.guardarPuntaje(_dificultadSeleccionada, nuevoPuntaje);
        } catch (_) {}

        if (!mounted) return;
        _mostrarPantallaVictoria(esNuevoRecord);
      } 
      else if (_tablero.contadorMovimientos >= _limiteMovimientos) {
        _timer?.cancel();
        _mostrarPantallaDerrota();
      }
    }
  }

  void _mostrarPantallaVictoria(bool esNuevoRecord) {
    final modo = AjustesView.modoTemaNotifier.value;
    final colorDialogo = modo == ThemeMode.light ? Colors.white : const Color(0xFF2A1B54);
    final colorTextoDialogo = modo == ThemeMode.light ? const Color(0xFF2D3436) : Colors.white;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorDialogo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFFEAA7), width: 2),
        ),
        title: Text(
          esNuevoRecord ? '¡NUEVO RÉCORD! 🏆🎉' : '¡Felicidades! 🎉',
          style: TextStyle(color: colorTextoDialogo, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¡Completaste el puzzle!\n\n'
          '${esNuevoRecord ? "🌟 ¡Es la mejor marca registrada en este modo!\n\n" : ""}'
          'Movimientos: ${_tablero.contadorMovimientos} / $_limiteMovimientos\n'
          'Tiempo: $_segundos segundos',
          style: TextStyle(color: colorTextoDialogo.withOpacity(0.8), fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7675),
              foregroundColor: const Color(0xFF1E272C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Menú Principal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF55EFC4),
              foregroundColor: const Color(0xFF1E272C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _iniciarPartida(_dificultadSeleccionada);
            },
            child: const Text('Reiniciar nivel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _mostrarPantallaDerrota() {
    _timer?.cancel();
    ServicioAudio.reproducirDerrota();

    final modo = AjustesView.modoTemaNotifier.value;
    final colorDialogo = modo == ThemeMode.light ? Colors.white : const Color(0xFF2A1B54);
    final colorTextoDialogo = modo == ThemeMode.light ? const Color(0xFF2D3436) : Colors.white;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorDialogo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFFEAA7), width: 2),
        ),
        title: Text(
          'Derrota',
          style: TextStyle(color: colorTextoDialogo, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Alcanzaste el límite máximo de movimientos.\n\n'
          'Movimientos: ${_tablero.contadorMovimientos} / $_limiteMovimientos\n'
          'Tiempo transcurrido: $_segundos segundos',
          style: TextStyle(color: colorTextoDialogo.withOpacity(0.8), fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7675),
              foregroundColor: const Color(0xFF1E272C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Menú Principal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF55EFC4),
              foregroundColor: const Color(0xFF1E272C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _iniciarPartida(_dificultadSeleccionada);
            },
            child: const Text('Reiniciar nivel', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AjustesView.modoTemaNotifier,
      builder: (context, _, __) {
        final colorTexto = TemaHelper.obtenerColorTexto(context);

        return Container(
          decoration: TemaHelper.obtenerDecoracionFondo(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: colorTexto),
              title: Text(
                !_enJuego ? 'Seleccionar Dificultad' : 'Puzzle (${_dificultadSeleccionada.toUpperCase()})',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
              ),
              leading: _enJuego
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _timer?.cancel();
                        setState(() => _enJuego = false);
                      },
                    )
                  : null,
              actions: _enJuego
                  ? [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reiniciar',
                        onPressed: () => _iniciarPartida(_dificultadSeleccionada),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flag_outlined),
                        tooltip: 'Rendirse',
                        onPressed: _mostrarPantallaDerrota,
                      )
                    ]
                  : null,
            ),
            body: !_enJuego ? _buildSeleccionDificultad() : _buildTableroJuego(context),
          ),
        );
      },
    );
  }

  Widget _buildSeleccionDificultad() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cuadritoDificultad(
                titulo: 'Fácil (3x3) - Máx. 300 mov.',
                color: const Color(0xFF55EFC4),
                onTap: () => _iniciarPartida('facil'),
              ),
              const SizedBox(height: 16),
              _cuadritoDificultad(
                titulo: 'Medio (4x4) - Máx. 500 mov.',
                color: const Color(0xFFFFEAA7),
                onTap: () => _iniciarPartida('medio'),
              ),
              const SizedBox(height: 16),
              _cuadritoDificultad(
                titulo: 'Difícil (5x5) - Máx. 700 mov.',
                color: const Color(0xFFFF7675),
                onTap: () => _iniciarPartida('dificil'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableroJuego(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatCard(context, 'Movimientos', '${_tablero.contadorMovimientos} / $_limiteMovimientos', Icons.touch_app_rounded),
            const SizedBox(width: 16),
            _buildStatCard(context, 'Tiempo', '${_segundos}s', Icons.timer_rounded),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450, maxHeight: 450),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TemaHelper.obtenerColorFondoTarjeta(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TemaHelper.obtenerColorBorde(context),
                        width: 1.5,
                      ),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _tablero.columnas,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _tablero.totalFichas,
                      itemBuilder: (context, index) {
                        int numero = _tablero.fichas[index];
                        if (numero == 0) return const SizedBox.shrink();

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _obtenerColorPieza(numero),
                            foregroundColor: const Color(0xFF1E272C),
                            elevation: 4,
                            shadowColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _onFichaTap(index),
                          child: Text(
                            '$numero',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String titulo, String valor, IconData icono) {
    final colorTexto = TemaHelper.obtenerColorTexto(context);
    final colorTarjeta = TemaHelper.obtenerColorFondoTarjeta(context);
    final colorBorde = TemaHelper.obtenerColorBorde(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: colorTarjeta,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorBorde),
      ),
      child: Row(
        children: [
          Icon(icono, color: const Color(0xFF55EFC4), size: 20),
          const SizedBox(width: 8),
          Text(
            '$titulo: ',
            style: TextStyle(color: colorTexto.withOpacity(0.7), fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            valor,
            style: TextStyle(color: colorTexto, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _cuadritoDificultad({required String titulo, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.2),
          foregroundColor: Colors.white,
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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