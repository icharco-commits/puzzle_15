import 'package:flutter/material.dart';
import '../servicios/servicio_audio.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({super.key});

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  bool _sonidoActivado = ServicioAudio.sonidoActivado;
  double _volumen = ServicioAudio.volumen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B2874),
            Color(0xFF6C5CE7),
            Color(0xFF2A1B54),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Ajustes',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
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
                    'SONIDO',
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
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF55EFC4),
                          activeTrackColor: const Color(0xFF55EFC4).withOpacity(0.35),
                          inactiveThumbColor: Colors.white54,
                          inactiveTrackColor: Colors.white12,
                          title: const Text(
                            'Efectos de sonido y música',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            _sonidoActivado ? 'Activado' : 'Desactivado',
                            style: TextStyle(
                              color: _sonidoActivado ? const Color(0xFF55EFC4) : Colors.white38,
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
                        const Divider(color: Colors.white12, height: 28),
                        Row(
                          children: [
                            const Icon(
                              Icons.volume_down_rounded,
                              color: Colors.white70,
                              size: 22,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: const Color(0xFFFF7675),
                                  inactiveTrackColor: Colors.white24,
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
                            const Icon(
                              Icons.volume_up_rounded,
                              color: Color(0xFFFF7675),
                              size: 22,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}