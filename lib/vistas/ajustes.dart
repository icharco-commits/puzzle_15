import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../servicios/servicio_audio.dart';
import '../servicios/tema_helper.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({super.key});

  static ValueNotifier<ThemeMode> modoTemaNotifier = ValueNotifier(ThemeMode.system);
  static ValueNotifier<String> estiloPiezasNotifier = ValueNotifier('Clásico');
  static ValueNotifier<String> dificultadNotifier = ValueNotifier('medio');

  static Future<void> cargarPreferenciasGuardadas() async {
    final prefs = await SharedPreferences.getInstance();
    
    final temaGuardado = prefs.getString('modo_tema') ?? 'system';
    if (temaGuardado == 'light') {
      modoTemaNotifier.value = ThemeMode.light;
    } else if (temaGuardado == 'dark') {
      modoTemaNotifier.value = ThemeMode.dark;
    } else {
      modoTemaNotifier.value = ThemeMode.system;
    }

    estiloPiezasNotifier.value = prefs.getString('estilo_piezas') ?? 'Clásico';
    dificultadNotifier.value = prefs.getString('dificultad_preferida') ?? 'medio';
  }

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  bool _sonidoActivado = ServicioAudio.sonidoActivado;
  double _volumen = ServicioAudio.volumen;

  Future<void> _guardarTema(ThemeMode modo) async {
    AjustesView.modoTemaNotifier.value = modo;
    final prefs = await SharedPreferences.getInstance();
    String valorString = 'system';
    if (modo == ThemeMode.light) valorString = 'light';
    if (modo == ThemeMode.dark) valorString = 'dark';
    await prefs.setString('modo_tema', valorString);
  }

  Future<void> _guardarEstiloPiezas(String estilo) async {
    AjustesView.estiloPiezasNotifier.value = estilo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estilo_piezas', estilo);
  }

  Future<void> _guardarDificultad(String dif) async {
    AjustesView.dificultadNotifier.value = dif;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dificultad_preferida', dif);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AjustesView.modoTemaNotifier,
      builder: (context, modoActual, _) {
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
              title: Text(
                'Ajustes',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
              ),
              iconTheme: IconThemeData(color: colorTexto),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  children: [
                    
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'SONIDO Y VOLUMEN',
                        style: TextStyle(
                          color: Color(0xFFFF7675),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorBorde, width: 1),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              activeThumbColor: const Color(0xFF55EFC4),
                              activeTrackColor: const Color(0xFF55EFC4).withValues(alpha: 0.35),
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.black12,
                              title: Text(
                                'Efectos de sonido',
                                style: TextStyle(
                                  color: colorTexto,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                _sonidoActivado ? 'Activado' : 'Desactivado',
                                style: TextStyle(
                                  color: _sonidoActivado ? const Color(0xFF55EFC4) : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              value: _sonidoActivado,
                              onChanged: (val) {
                                setState(() {
                                  _sonidoActivado = val;
                                  ServicioAudio.actualizarAjustes(
                                    activado: _sonidoActivado,
                                    nuevoVolumen: _volumen,
                                  );
                                });
                              },
                            ),
                          ),
                          if (_sonidoActivado) ...[
                            const Divider(height: 28),
                            Row(
                              children: [
                                Icon(Icons.volume_down_rounded, color: colorTexto, size: 22),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFFFF7675),
                                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                                      thumbColor: const Color(0xFFFF7675),
                                      overlayColor: const Color(0xFFFF7675).withValues(alpha: 0.2),
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                                    ),
                                    child: Slider(
                                      value: _volumen,
                                      onChanged: (val) {
                                        setState(() {
                                          _volumen = val;
                                          ServicioAudio.actualizarAjustes(
                                            activado: _sonidoActivado,
                                            nuevoVolumen: _volumen,
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const Icon(Icons.volume_up_rounded, color: Color(0xFFFF7675), size: 22),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'DIFICULTAD PREDETERMINADA',
                        style: TextStyle(
                          color: Color(0xFF74B9FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorBorde, width: 1),
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: AjustesView.dificultadNotifier,
                        builder: (context, difActual, _) {
                          return DropdownButtonFormField<String>(
                            key: ValueKey(difActual),
                            dropdownColor: modoActual == ThemeMode.light
                                ? Colors.white
                                : (modoActual == ThemeMode.dark ? const Color(0xFF1E1E1E) : const Color(0xFF2A1B54)),
                            style: TextStyle(color: colorTexto, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Dificultad Inicial',
                              labelStyle: TextStyle(color: colorTexto.withValues(alpha: 0.7)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF74B9FF))),
                            ),
                            initialValue: difActual,
                            items: [
                              DropdownMenuItem(
                                value: 'facil',
                                child: Text('Fácil (3x3 - 8 piezas)', style: TextStyle(color: colorTexto)),
                              ),
                              DropdownMenuItem(
                                value: 'medio',
                                child: Text('Medio (4x4 - 15 piezas)', style: TextStyle(color: colorTexto)),
                              ),
                              DropdownMenuItem(
                                value: 'dificil',
                                child: Text('Difícil (5x5 - 24 piezas)', style: TextStyle(color: colorTexto)),
                              ),
                            ],
                            onChanged: (nuevaDif) {
                              if (nuevaDif != null) {
                                _guardarDificultad(nuevaDif);
                              }
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'TEMA VISUAL',
                        style: TextStyle(
                          color: Color(0xFFFFEAA7),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorBorde, width: 1),
                      ),
                      child: DropdownButtonFormField<ThemeMode>(
                        key: ValueKey(modoActual),
                        dropdownColor: modoActual == ThemeMode.light
                            ? Colors.white
                            : (modoActual == ThemeMode.dark ? const Color(0xFF1E1E1E) : const Color(0xFF2A1B54)),
                        style: TextStyle(color: colorTexto, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Modo de Tema',
                          labelStyle: TextStyle(color: colorTexto.withValues(alpha: 0.7)),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFEAA7))),
                        ),
                        initialValue: modoActual,
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('Predeterminado / Sistema', style: TextStyle(color: colorTexto)),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Claro (Fondo Blanco)', style: TextStyle(color: colorTexto)),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Oscuro (Fondo Negro)', style: TextStyle(color: colorTexto)),
                          ),
                        ],
                        onChanged: (nuevoModo) {
                          if (nuevoModo != null) {
                            _guardarTema(nuevoModo);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                   
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'ESTILO DE FICHAS',
                        style: TextStyle(
                          color: Color(0xFF55EFC4),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorBorde, width: 1),
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: AjustesView.estiloPiezasNotifier,
                        builder: (context, estiloActual, _) {
                          return DropdownButtonFormField<String>(
                            key: ValueKey(estiloActual),
                            dropdownColor: modoActual == ThemeMode.light
                                ? Colors.white
                                : (modoActual == ThemeMode.dark ? const Color(0xFF1E1E1E) : const Color(0xFF2A1B54)),
                            style: TextStyle(color: colorTexto, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Diseño de Piezas',
                              labelStyle: TextStyle(color: colorTexto.withValues(alpha: 0.7)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF55EFC4))),
                            ),
                            initialValue: estiloActual,
                            items: [
                              DropdownMenuItem(
                                value: 'Clásico',
                                child: Text('Clásico Numérico (Amarillo)', style: TextStyle(color: colorTexto)),
                              ),
                              DropdownMenuItem(
                                value: 'Colorido',
                                child: Text('Colorido (Multicolor Neón)', style: TextStyle(color: colorTexto)),
                              ),
                            ],
                            onChanged: (nuevoEstilo) {
                              if (nuevoEstilo != null) {
                                _guardarEstiloPiezas(nuevoEstilo);
                              }
                            },
                          );
                        },
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