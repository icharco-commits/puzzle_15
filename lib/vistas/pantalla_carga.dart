import 'dart:async';
import 'package:flutter/material.dart';
import 'menu_principal.dart';
import 'ajustes.dart';
import '../servicios/tema_helper.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timerNavegacion;
  bool _haNavegado = false;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación de escala y opacidad
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Navegación automática tras 2.5 segundos
    _timerNavegacion = Timer(const Duration(milliseconds: 2500), () {
      _irAlMenu();
    });
  }

  void _irAlMenu() {
    if (_haNavegado || !mounted) return;
    _haNavegado = true;
    _timerNavegacion?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPrincipal()),
    );
  }

  @override
  void dispose() {
    _timerNavegacion?.cancel();
    _animController.dispose();
    super.dispose();
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
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Ícono animado con escala y opacidad pulsante
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF55EFC4),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.extension_rounded,
                              size: 80,
                              color: Color(0xFFFFEAA7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '15-PUZZLE FLUTTER',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: colorTexto,
                        ),
                      ),
                      const SizedBox(height: 36),
                      const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF55EFC4)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón Saltar en la esquina superior
                Positioned(
                  top: 40,
                  right: 20,
                  child: TextButton.icon(
                    onPressed: _irAlMenu,
                    icon: const Icon(Icons.skip_next_rounded, color: Color(0xFF55EFC4)),
                    label: const Text(
                      'Saltar',
                      style: TextStyle(
                        color: Color(0xFF55EFC4),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}