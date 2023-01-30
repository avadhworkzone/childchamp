import 'package:childchamp/utils/sound_utils.dart';
import 'package:just_audio/just_audio.dart';

class SoundService {
  static final player = AudioPlayer();
  static final bgPlayer = AudioPlayer();

  /// WIN LOSE SOUND
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

  /// BACKGROUND SOUND

  static Future<void> setBgPlayerPath() async {
    await bgPlayer.setAsset(SoundUtils.bgSound);
    await bgPlayer.setVolume(0.1);
  }

  static Future<void> playBgPlayer() async {
    bgPlayer.play();
    bgPlayer.setLoopMode(LoopMode.all);
  }

  static void stopBgPlayer() {
    bgPlayer.pause();
  }

  static void disposeBgPlayer() {
    bgPlayer.dispose();
  }

  static void resumeBgPlayer() {
    bgPlayer.play();
  }
}
