import 'package:flutter/material.dart';
import 'vistas/pantalla_carga.dart'; 
import 'vistas/ajustes.dart';
import 'servicios/servicio_audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServicioAudio.iniciarMusicaFondo();
  runApp(const MiAppPuzzle());
}

class MiAppPuzzle extends StatelessWidget {
  const MiAppPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AjustesView.modoTemaNotifier,
      builder: (context, modoTema, _) {
        return MaterialApp(
          title: '15 Puzzle',
          debugShowCheckedModeBanner: false,
          themeMode: modoTema,
          home: const PantallaCarga(), 
        );
      },
    );
  }
}