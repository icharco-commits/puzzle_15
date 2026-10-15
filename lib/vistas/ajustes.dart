import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Usa StatefulWidget porque la pantalla cambia de estado al prender/apagar el switch
class AjustesPantalla extends StatefulWidget {
  const AjustesPantalla({super.key});

  @override
  State<AjustesPantalla> createState() => _AjustesPantallaState();
}

class _AjustesPantallaState extends State<AjustesPantalla> {
  bool sonidoActivado = true; // Por defecto el sonido viene activado

  @override
  void initState() {
    super.initState();
    _cargarAjustes(); // Carga las preferencias penas entra a la pantalla
  }

  // Busca en la memoria del teléfono si el usuario había apagado el sonido
  Future<void> _cargarAjustes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sonidoActivado = prefs.getBool('sonido') ?? true;
    });
  }

  // Guarda la opción en la memoria local cuando el usuario toca el interruptor
  Future<void> _guardarAjustes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sonido', sonidoActivado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C003E), Color(0xFF0F0C29)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tarjetita transparente con el switch para prender/apagar sonido
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SwitchListTile(
                title: const Text(
                  'Efectos de Sonido',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Activar sonidos al deslizar fichas',
                  style: TextStyle(color: Colors.white70),
                ),
                activeColor: Colors.cyanAccent,
                value: sonidoActivado,
                onChanged: (valor) {
                  setState(() {
                    sonidoActivado = valor; // Actualiza el switch en pantalla
                  });
                  _guardarAjustes(); // Guarda la preferencia en memoria
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}