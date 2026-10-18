import 'package:flutter/material.dart';
import 'vistas/menu_principal.dart';
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
    return MaterialApp(
      title: '15 Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}