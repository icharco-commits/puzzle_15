import 'package:flutter/material.dart';
import 'vista_juego.dart';
import 'puntuaciones.dart';
import 'ajustes.dart';
import 'instrucciones.dart';
import '../servicios/tema_helper.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navegarA(Widget pantalla) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => pantalla,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
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
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ENCABEZADO / ÍCONOS DEL LOGO
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _CajaIcono(
                                colorFondo: Color(0xFF00CEC9),
                                icon: Icons.extension,
                              ),
                              SizedBox(width: 12),
                              _CajaIcono(
                                colorFondo: Color(0xFFE84393),
                                icon: Icons.extension,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '15-PUZZLE FLUTTER',
                            style: TextStyle(
                              fontSize: 32,
                              color: colorTexto,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // BOTÓN JUGAR
                          _BotonMenuEspecial(
                            label: 'JUGAR',
                            icon: Icons.play_arrow_rounded,
                            colorFondo: const Color(0xFF55EFC4),
                            colorTexto: const Color(0xFF1E272C),
                            onPressed: () => _navegarA(const VistaJuego()),
                          ),
                          const SizedBox(height: 16),

                          // BOTÓN PUNTUACIONES
                          _BotonMenuEspecial(
                            label: 'PUNTUACIONES',
                            icon: Icons.emoji_events_rounded,
                            colorFondo: const Color(0xFFFFEAA7),
                            colorTexto: const Color(0xFF1E272C),
                            onPressed: () => _navegarA(const PuntuacionesView()),
                          ),
                          const SizedBox(height: 16),

                          // BOTÓN INSTRUCCIONES
                          _BotonMenuEspecial(
                            label: 'INSTRUCCIONES',
                            icon: Icons.help_outline_rounded,
                            colorFondo: const Color(0xFF74B9FF),
                            colorTexto: const Color(0xFF1E272C),
                            onPressed: () => _navegarA(const InstruccionesView()),
                          ),
                          const SizedBox(height: 16),

                          // BOTÓN AJUSTES
                          _BotonMenuEspecial(
                            label: 'AJUSTES',
                            icon: Icons.settings_rounded,
                            colorFondo: const Color(0xFFFF7675),
                            colorTexto: Colors.white,
                            onPressed: () => _navegarA(const AjustesView()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorFondo.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}

class _BotonMenuEspecial extends StatefulWidget {
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
  State<_BotonMenuEspecial> createState() => _BotonMenuEspecialState();
}

class _BotonMenuEspecialState extends State<_BotonMenuEspecial> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) {
        setState(() => _presionado = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _presionado = false),
      child: AnimatedScale(
        scale: _presionado ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 250,
          height: 54,
          decoration: BoxDecoration(
            color: _presionado
                ? widget.colorFondo.withValues(alpha: 0.8)
                : widget.colorFondo,
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: widget.colorFondo.withValues(
                  alpha: _presionado ? 0.7 : 0.35,
                ),
                blurRadius: _presionado ? 16 : 8,
                spreadRadius: _presionado ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.colorTexto,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}