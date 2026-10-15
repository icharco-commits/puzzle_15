import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'puntuaciones.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  // Ventana flotante para elegir el tamaño del tablero antes de entrar a jugar
  void _mostrarSelectorNiveles(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF24243E),
        title: const Text(
          'Selecciona el Nivel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BotonNivel(
              titulo: 'Fácil (3 x 3)',
              color: Colors.greenAccent,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _BotonNivel(
              titulo: 'Clásico (4 x 4)',
              color: Colors.cyanAccent,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _BotonNivel(
              titulo: 'Difícil (5 x 5)',
              color: Colors.amberAccent,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo superior con las dos piezas de rompecabezas entrelazadas (Cian y Morada)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                    ),
                    child: const Icon(
                      Icons.extension_rounded,
                      size: 45,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purpleAccent, width: 2),
                    ),
                    child: const Icon(
                      Icons.extension_rounded,
                      size: 45,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Título principal
              const Text(
                '15 PUZZLE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),

              // Botón Jugar
              _BotonMenu(
                label: 'JUGAR',
                icon: Icons.play_arrow_rounded,
                color: Colors.greenAccent.shade400,
                textoColor: Colors.black,
                onPressed: () => _mostrarSelectorNiveles(context),
              ),
              const SizedBox(height: 16),

              // Botón Puntuaciones
              _BotonMenu(
                label: 'PUNTUACIONES',
                icon: Icons.emoji_events_rounded,
                color: Colors.amberAccent,
                textoColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PuntuacionesPantalla()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Botón Ajustes
              _BotonMenu(
                label: 'AJUSTES',
                icon: Icons.settings_rounded,
                color: Colors.purpleAccent,
                textoColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AjustesPantalla()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textoColor;
  final VoidCallback onPressed;

  const _BotonMenu({
    required this.label,
    required this.icon,
    required this.color,
    required this.textoColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textoColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
            color: textoColor,
          ),
        ),
      ),
    );
  }
}

class _BotonNivel extends StatelessWidget {
  final String titulo;
  final Color color;
  final VoidCallback onTap;

  const _BotonNivel({required this.titulo, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}