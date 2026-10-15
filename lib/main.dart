import 'package:flutter/material.dart';
import 'vistas/menu_principal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '15-Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF0F0C29),
      ),
      home: const Scaffold(
        body: MenuPrincipal(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'UNIMET • Miniproyecto 15-Puzzle',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}