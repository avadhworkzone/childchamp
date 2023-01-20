import 'package:just_audio/just_audio.dart';

class SoundService {
  static final player = AudioPlayer();

  static Future<void> setPlayer(String path) async {
    await player.setAsset(path);
    player.play();
  }

  static void stopPlayer() {
    player.stop();
  }

  static void disposePlayer() {
    player.dispose();
  }

  static void repeatSound() {
    player.load();
  }
}
