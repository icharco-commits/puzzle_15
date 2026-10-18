import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EntradaPuntaje {
  final int tiempoSegundos;
  final int movimientos;
  final String fecha;

  EntradaPuntaje({
    required this.tiempoSegundos,
    required this.movimientos,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'tiempoSegundos': tiempoSegundos,
        'movimientos': movimientos,
        'fecha': fecha,
      };

  factory EntradaPuntaje.fromJson(Map<String, dynamic> json) {
    return EntradaPuntaje(
      tiempoSegundos: json['tiempoSegundos'] ?? 0,
      movimientos: json['movimientos'] ?? 0,
      fecha: json['fecha'] ?? '',
    );
  }
}

class Almacenamiento {
  static Future<List<EntradaPuntaje>> obtenerPuntajes(String dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    final String? datosJson = prefs.getString('puntajes_$dificultad');
    if (datosJson == null) return [];

    final List<dynamic> decoded = jsonDecode(datosJson);
    return decoded.map((item) => EntradaPuntaje.fromJson(item)).toList();
  }

  static Future<void> guardarPuntaje(String dificultad, EntradaPuntaje nuevoPuntaje) async {
    final prefs = await SharedPreferences.getInstance();
    List<EntradaPuntaje> lista = await obtenerPuntajes(dificultad);
    lista.add(nuevoPuntaje);
    
    // Ordenar por menor cantidad de movimientos
    lista.sort((a, b) => a.movimientos.compareTo(b.movimientos));

    final String encoded = jsonEncode(lista.map((e) => e.toJson()).toList());
    await prefs.setString('puntajes_$dificultad', encoded);
  }

  static Future<void> limpiarPuntajes(String dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('puntajes_$dificultad');
  }
}