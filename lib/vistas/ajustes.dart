import 'package:flutter/material.dart';
import '../servicios/servicio_audio.dart';
import '../servicios/tema_helper.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({super.key});

  static ValueNotifier<ThemeMode> modoTemaNotifier = ValueNotifier(ThemeMode.system);
  static ValueNotifier<String> estiloPiezasNotifier = ValueNotifier('Clásico');

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  bool _sonidoActivado = ServicioAudio.sonidoActivado;
  double _volumen = ServicioAudio.volumen;

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
                    // 🔊 SECCIÓN SONIDO
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
                              activeColor: const Color(0xFF55EFC4),
                              activeTrackColor: const Color(0xFF55EFC4).withOpacity(0.35),
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.black12,
                              title: Text(
                                'Efectos de sonido y música',
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
                                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                                      thumbColor: const Color(0xFFFF7675),
                                      overlayColor: const Color(0xFFFF7675).withOpacity(0.2),
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

                    // 🎨 SECCIÓN DE TEMA VISUAL
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
                        dropdownColor: modoActual == ThemeMode.light
                            ? Colors.white
                            : (modoActual == ThemeMode.dark ? const Color(0xFF1E1E1E) : const Color(0xFF2A1B54)),
                        style: TextStyle(color: colorTexto, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Modo de Tema',
                          labelStyle: TextStyle(color: colorTexto.withOpacity(0.7)),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFEAA7))),
                        ),
                        value: modoActual,
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('Predeterminado (Morado Neón)', style: TextStyle(color: colorTexto)),
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
                            AjustesView.modoTemaNotifier.value = nuevoModo;
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🧩 SECCIÓN DE ESTILO DE FICHAS
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
                            dropdownColor: modoActual == ThemeMode.light
                                ? Colors.white
                                : (modoActual == ThemeMode.dark ? const Color(0xFF1E1E1E) : const Color(0xFF2A1B54)),
                            style: TextStyle(color: colorTexto, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Diseño de Piezas',
                              labelStyle: TextStyle(color: colorTexto.withOpacity(0.7)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF55EFC4))),
                            ),
                            value: estiloActual,
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
                                AjustesView.estiloPiezasNotifier.value = nuevoEstilo;
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