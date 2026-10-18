import 'package:flutter/material.dart';

class AjustesView extends StatefulWidget {
  const AjustesView({super.key});

  @override
  State<AjustesView> createState() => _AjustesViewState();
}

class _AjustesViewState extends State<AjustesView> {
  double _volumen = 0.8; // Valor del volumen entre 0.0 y 1.0
  bool _sonidoActivado = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo totalmente negro
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SONIDO',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // Switch de Activar/Desactivar Sonido
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFFFF7675), // Mismo rosado neón de tu menú
              title: const Text(
                'Efectos de sonido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                _sonidoActivado ? 'Activado' : 'Silenciado',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              value: _sonidoActivado,
              onChanged: (bool value) {
                setState(() {
                  _sonidoActivado = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Slider para ajustar/subir/bajar volumen
            Row(
              children: [
                Icon(
                  _volumen == 0 || !_sonidoActivado
                      ? Icons.volume_off
                      : Icons.volume_down,
                  color: Colors.white70,
                ),
                Expanded(
                  child: Slider(
                    value: _sonidoActivado ? _volumen : 0.0,
                    activeColor: const Color(0xFFFF7675),
                    inactiveColor: Colors.white24,
                    min: 0.0,
                    max: 1.0,
                    onChanged: _sonidoActivado
                        ? (double value) {
                            setState(() {
                              _volumen = value;
                            });
                          }
                        : null,
                  ),
                ),
                Icon(
                  Icons.volume_up,
                  color: _sonidoActivado ? Colors.white70 : Colors.white24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}