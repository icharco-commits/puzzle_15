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
  late String _dificultadSeleccionada;
  int _limiteMovimientos = 500;
  bool _primerMovimientoHecho = false;

  @override
  void initState() {
    super.initState();
    // Obtiene automáticamente la dificultad configurada desde los Ajustes
    _dificultadSeleccionada = AjustesView.dificultadNotifier.value;
    _iniciarPartida(_dificultadSeleccionada);
  }

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
          esNuevoRecord ? '¡NUEVO RÉCORD!' : '¡Felicidades!',
          style: TextStyle(color: colorTextoDialogo, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¡Completaste el puzzle!\n\n'
          '${esNuevoRecord ? "¡Es la mejor marca registrada en este modo!\n\n" : ""}'
          'Movimientos: ${_tablero.contadorMovimientos} / $_limiteMovimientos\n'
          'Tiempo: $_segundos segundos',
          style: TextStyle(color: colorTextoDialogo.withValues(alpha: 0.8), fontSize: 16),
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
          style: TextStyle(color: colorTextoDialogo.withValues(alpha: 0.8), fontSize: 16),
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
                'Puzzle (${_dificultadSeleccionada.toUpperCase()})',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.flag_outlined),
                  tooltip: 'Rendirse',
                  onPressed: _mostrarPantallaDerrota,
                ),
              ],
            ),
            body: _buildTableroJuego(context),
          ),
        );
      },
    );
  }

  // DISEÑO CENTRALIZADO RESPONSIVO (ESTADÍSTICAS ARRIBA, TABLERO AL CENTRO)
  Widget _buildTableroJuego(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double alturaDisponible = constraints.maxHeight;
        final double tamanoTablero = (alturaDisponible * 0.55).clamp(240.0, 460.0);

        Widget tarjetasEstadisticas = Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            _buildStatCard(
              context, 
              'Movimientos', 
              '${_tablero.contadorMovimientos} / $_limiteMovimientos', 
              Icons.touch_app_rounded
            ),
            _buildStatCard(
              context, 
              'Tiempo', 
              '${_segundos}s', 
              Icons.timer_rounded
            ),
          ],
        );

        Widget contenedorTablero = SizedBox(
          width: tamanoTablero,
          height: tamanoTablero,
          child: Container(
            padding: EdgeInsets.all(constraints.maxWidth < 360 ? 8 : 12),
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
                crossAxisSpacing: constraints.maxWidth < 360 ? 5 : 8,
                mainAxisSpacing: constraints.maxWidth < 360 ? 5 : 8,
              ),
              itemCount: _tablero.totalFichas,
              itemBuilder: (context, index) {
                int numero = _tablero.fichas[index];
                if (numero == 0) return const SizedBox.shrink();

                final double tamanoFuente = tamanoTablero / (_tablero.columnas * 3.6);

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _obtenerColorPieza(numero),
                    foregroundColor: const Color(0xFF1E272C),
                    elevation: 4,
                    shadowColor: Colors.black38,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _onFichaTap(index),
                  child: Text(
                    '$numero',
                    style: TextStyle(
                      fontSize: tamanoFuente.clamp(14.0, 32.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tarjetasEstadisticas,
                  const SizedBox(height: 18),
                  contenedorTablero,
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF55EFC4),
                      foregroundColor: const Color(0xFF1E272C),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _iniciarPartida(_dificultadSeleccionada),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar Partida', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String titulo, String valor, IconData icono) {
    final colorTexto = TemaHelper.obtenerColorTexto(context);
    final colorTarjeta = TemaHelper.obtenerColorFondoTarjeta(context);
    final colorBorde = TemaHelper.obtenerColorBorde(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorTarjeta,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorBorde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: const Color(0xFF55EFC4), size: 20),
          const SizedBox(width: 8),
          Text(
            '$titulo: ',
            style: TextStyle(color: colorTexto.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            valor,
            style: TextStyle(color: colorTexto, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}