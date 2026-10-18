import 'package:audioplayers/audioplayers.dart';

class ServicioAudio {
  static final AudioPlayer _reproductorEfectos = AudioPlayer();

  static bool sonidoActivado = true;
  static double volumen = 0.8;

  // 1. Efecto al mover ficha
  static Future<void> reproducirMoverFicha() async {
    if (!sonidoActivado) return;
    try {
      await _reproductorEfectos.stop();
      await _reproductorEfectos.setVolume(volumen);
      await _reproductorEfectos.play(AssetSource('sonidos/deslizar.wav'));
    } catch (_) {}
  }

  // 2. Efecto de Victoria
  static Future<void> reproducirVictoria() async {
    if (!sonidoActivado) return;
    try {
      await _reproductorEfectos.stop();
      await _reproductorEfectos.setVolume(volumen);
      await _reproductorEfectos.play(AssetSource('sonidos/victoria.wav'));
    } catch (_) {}
  }

  // 3. Efecto de Derrota
  static Future<void> reproducirDerrota() async {
    if (!sonidoActivado) return;
    try {
      await _reproductorEfectos.stop();
      await _reproductorEfectos.setVolume(volumen);
      await _reproductorEfectos.play(AssetSource('sonidos/derrota.wav'));
    } catch (_) {}
  }

  // Sincronización con la pantalla de Ajustes
  static void actualizarAjustes({required bool activado, required double nuevoVolumen}) {
    sonidoActivado = activado;
    volumen = nuevoVolumen;
  }
}