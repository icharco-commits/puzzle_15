import 'package:flutter/material.dart';
import 'vistas/pantalla_carga.dart'; 
import 'vistas/ajustes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carga de preferencias guardadas (tema, sonido, estilo de fichas)
  await AjustesView.cargarPreferenciasGuardadas();
  
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
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const PantallaCarga(), 
        );
      },
    );
  }
}