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

  factory EntradaPuntaje.fromJson(Map<String, dynamic> json) => EntradaPuntaje(
        tiempoSegundos: json['tiempoSegundos'] ?? 0,
        movimientos: json['movimientos'] ?? 0,
        fecha: json['fecha'] ?? '',
      );
}

class Almacenamiento {
  static const String _claveDificultad = 'pref_dificultad';
  static const String _claveTema = 'pref_tema';
  static const String _claveEstiloPieza = 'pref_estilo_pieza';

  // Dificultad, tema y estilo
  static Future<void> guardarDificultad(String dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveDificultad, dificultad);
  }

  static Future<String> obtenerDificultad() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveDificultad) ?? 'medio';
  }

  static Future<void> guardarTema(String modo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveTema, modo);
  }

  static Future<String> obtenerTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveTema) ?? 'sistema';
  }

  static Future<void> guardarEstiloPieza(String estilo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveEstiloPieza, estilo);
  }

  static Future<String> obtenerEstiloPieza() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_claveEstiloPieza) ?? 'clasico';
  }

  // Historial de mejores puntajes
  static Future<void> guardarPuntaje(String dificultad, EntradaPuntaje nuevoPuntaje) async {
    final prefs = await SharedPreferences.getInstance();
    final String clave = 'puntajes_$dificultad';
    List<EntradaPuntaje> lista = await obtenerPuntajes(dificultad);

    lista.add(nuevoPuntaje);
    lista.sort((a, b) {
      int compMov = a.movimientos.compareTo(b.movimientos);
      if (compMov != 0) return compMov;
      return a.tiempoSegundos.compareTo(b.tiempoSegundos);
    });

    if (lista.length > 5) {
      lista = lista.sublist(0, 5);
    }

    List<String> rawJson = lista.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(clave, rawJson);
  }

  static Future<List<EntradaPuntaje>> obtenerPuntajes(String dificultad) async {
    final prefs = await SharedPreferences.getInstance();
    final String clave = 'puntajes_$dificultad';
    List<String>? rawJson = prefs.getStringList(clave);

    if (rawJson == null) return [];

    return rawJson.map((e) => EntradaPuntaje.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> borrarPuntajes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('puntajes_facil');
    await prefs.remove('puntajes_medio');
    await prefs.remove('puntajes_dificil');
  }
}