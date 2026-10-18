import 'package:audioplayers/audioplayers.dart';

class ServicioAudio {
  static final AudioPlayer _reproductorFondo = AudioPlayer();
  static final AudioPlayer _reproductorEfectos = AudioPlayer();

  static bool sonidoActivado = true;
  static double volumen = 0.8;

  // 1. Música de fondo continua (en bucle)
  static Future<void> iniciarMusicaFondo() async {
    if (!sonidoActivado) return;
    await _reproductorFondo.setReleaseMode(ReleaseMode.loop);
    await _reproductorFondo.setVolume(volumen * 0.35); // Volumen suave de fondo
    await _reproductorFondo.play(AssetSource('sonidos/fondo.mp3'));
  }

  // 2. Efecto al mover ficha
  static Future<void> reproducirMoverFicha() async {
    if (!sonidoActivado) return;
    await _reproductorEfectos.stop();
    await _reproductorEfectos.setVolume(volumen);
    await _reproductorEfectos.play(AssetSource('sonidos/deslizar.wav')); // Ajusta extensión si es .mp3
  }

  // 3. Efecto de Victoria
  static Future<void> reproducirVictoria() async {
    if (!sonidoActivado) return;
    await _reproductorEfectos.stop();
    await _reproductorEfectos.setVolume(volumen);
    await _reproductorEfectos.play(AssetSource('sonidos/victoria.wav')); // Ajusta extensión si es .wav
  }

  // 4. Efecto de Derrota
  static Future<void> reproducirDerrota() async {
    if (!sonidoActivado) return;
    await _reproductorEfectos.stop();
    await _reproductorEfectos.setVolume(volumen);
    await _reproductorEfectos.play(AssetSource('sonidos/derrota.wav')); // Ajusta extensión si es .wav
  }

  // Sincronización con la pantalla de Ajustes
  static void actualizarAjustes({required bool activado, required double nuevoVolumen}) {
    sonidoActivado = activado;
    volumen = nuevoVolumen;
    _reproductorFondo.setVolume(volumen * 0.35);

    if (!sonidoActivado) {
      _reproductorFondo.pause();
    } else {
      if (_reproductorFondo.state == PlayerState.paused) {
        _reproductorFondo.resume();
      } else if (_reproductorFondo.state == PlayerState.stopped) {
        iniciarMusicaFondo();
      }
    }
  }
}