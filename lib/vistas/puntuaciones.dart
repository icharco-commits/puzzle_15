import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuntuacionesPantalla extends StatefulWidget {
  const PuntuacionesPantalla({super.key});

  @override
  State<PuntuacionesPantalla> createState() => _PuntuacionesPantallaState();
}

class _PuntuacionesPantallaState extends State<PuntuacionesPantalla> {
  List<String> listaPuntuaciones = []; // Aquí se van a guardar los tiempos/récords

  @override
  void initState() {
    super.initState();
    _cargarPuntuaciones(); // Lee las puntuaciones guardadas apenas abre la vista
  }

  // Lee la lista guardada en la memoria local con clave 'mejores_tiempos'
  Future<void> _cargarPuntuaciones() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      listaPuntuaciones = prefs.getStringList('mejores_tiempos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Puntuaciones', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0C29), Color(0xFF24243E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        // Si no hay partidas jugadas muestra un texto simple, si no, genera la lista
        child: listaPuntuaciones.isEmpty
            ? const Center(
                child: Text(
                  '¡Aún no hay puntuaciones registradas!\nJuega una partida para guardar tu récord.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: listaPuntuaciones.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white.withOpacity(0.15),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      // Muestra la posición (1, 2, 3...) dentro de un circulito dorado
                      leading: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        listaPuntuaciones[index],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      trailing: const Icon(Icons.emoji_events, color: Colors.amber), // Iconito de trofeo
                    ),
                  );
                },
              ),
      ),
    );
  }
}