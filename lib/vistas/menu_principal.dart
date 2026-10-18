import 'package:flutter/material.dart';
import 'vista_juego.dart';
import 'puntuaciones.dart';
import 'ajustes.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B2874), // Morado superior
              Color(0xFF6C5CE7), // Morado brillante
              Color(0xFF2A1B54), // Morado oscuro inferior
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Íconos de piezas de rompecabezas de arriba
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CajaIcono(
                  colorFondo: const Color(0xFF00CEC9), // Cian / Turquesa
                  icon: Icons.extension,
                ),
                const SizedBox(width: 12),
                _CajaIcono(
                  colorFondo: const Color(0xFFE84393), // Rosado
                  icon: Icons.extension,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '15 PUZZLE',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),

            // Botón JUGAR (Verde Neón)
            _BotonMenuEspecial(
              label: 'JUGAR',
              icon: Icons.play_arrow_rounded,
              colorFondo: const Color(0xFF55EFC4),
              colorTexto: const Color(0xFF1E272C),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VistaJuego(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Botón PUNTUACIONES (Amarillo Neón)
            _BotonMenuEspecial(
              label: 'PUNTUACIONES',
              icon: Icons.emoji_events_rounded,
              colorFondo: const Color(0xFFFFEAA7),
              colorTexto: const Color(0xFF1E272C),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PuntuacionesView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Botón AJUSTES (Rosado Neón)
            _BotonMenuEspecial(
              label: 'AJUSTES',
              icon: Icons.settings_rounded,
              colorFondo: const Color(0xFFFF7675),
              colorTexto: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AjustesView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CajaIcono extends StatelessWidget {
  final Color colorFondo;
  final IconData icon;

  const _CajaIcono({
    required this.colorFondo,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

class _BotonMenuEspecial extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color colorFondo;
  final Color colorTexto;
  final VoidCallback onPressed;

  const _BotonMenuEspecial({
    required this.label,
    required this.icon,
    required this.colorFondo,
    required this.colorTexto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo,
          foregroundColor: colorTexto,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: colorTexto),
        label: Text(
          label,
          style: TextStyle(
            color: colorTexto,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}