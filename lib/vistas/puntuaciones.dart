import 'package:flutter/material.dart';
import '../servicios/almacenamiento.dart';
import '../servicios/tema_helper.dart';
import 'ajustes.dart';

class PuntuacionesView extends StatefulWidget {
  const PuntuacionesView({super.key});

  @override
  State<PuntuacionesView> createState() => _PuntuacionesViewState();
}

class _PuntuacionesViewState extends State<PuntuacionesView> {
  String _dificultadSeleccionada = 'facil';
  List<EntradaPuntaje> _puntajes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPuntajes();
  }

  Future<void> _cargarPuntajes() async {
    setState(() => _cargando = true);
    final lista = await Almacenamiento.obtenerPuntajes(_dificultadSeleccionada);
    setState(() {
      _puntajes = lista;
      _cargando = false;
    });
  }

  void _mostrarDialogoConfirmacion() {
    final modo = AjustesView.modoTemaNotifier.value;
    final colorDialogo = modo == ThemeMode.light ? Colors.white : const Color(0xFF2A1B54);
    final colorTextoDialogo = modo == ThemeMode.light ? const Color(0xFF2D3436) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorDialogo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFF7675), width: 2),
        ),
        title: Text(
          'Borrar Puntuaciones',
          style: TextStyle(color: colorTextoDialogo, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar las puntuaciones de esta dificultad?',
          style: TextStyle(color: colorTextoDialogo.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7675),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await Almacenamiento.limpiarPuntajes(_dificultadSeleccionada);
              _cargarPuntajes();
            },
            child: const Text('Sí, borrar', style: TextStyle(fontWeight: FontWeight.bold)),
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
                'Puntuaciones',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF7675)),
                  tooltip: 'Borrar Puntuaciones',
                  onPressed: _mostrarDialogoConfirmacion,
                ),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botonFiltro('Fácil', 'facil', const Color(0xFF55EFC4)),
                    const SizedBox(width: 8),
                    _botonFiltro('Medio', 'medio', const Color(0xFFFFEAA7)),
                    const SizedBox(width: 8),
                    _botonFiltro('Difícil', 'dificil', const Color(0xFFFF7675)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator())
                      : _puntajes.isEmpty
                          ? Center(
                              child: Text(
                                'No hay marcas en esta dificultad',
                                style: TextStyle(color: colorTexto.withValues(alpha: 0.6), fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              itemCount: _puntajes.length,
                              itemBuilder: (ctx, index) {
                                final p = _puntajes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorTarjeta,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: colorBorde),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '#${index + 1}',
                                            style: const TextStyle(
                                              color: Color(0xFFFFEAA7),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${p.movimientos} Movimientos',
                                                style: TextStyle(
                                                  color: colorTexto,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Tiempo: ${p.tiempoSegundos}s',
                                                style: TextStyle(
                                                  color: colorTexto.withValues(alpha: 0.7),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        p.fecha,
                                        style: TextStyle(
                                          color: colorTexto.withValues(alpha: 0.5),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _botonFiltro(String etiqueta, String clave, Color color) {
    final bool seleccionado = _dificultadSeleccionada == clave;
    return ChoiceChip(
      label: Text(
        etiqueta,
        style: TextStyle(
          color: seleccionado ? const Color(0xFF1E272C) : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: seleccionado,
      selectedColor: color,
      backgroundColor: color.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color),
      ),
      onSelected: (val) {
        if (val) {
          setState(() => _dificultadSeleccionada = clave);
          _cargarPuntajes();
        }
      },
    );
  }
}