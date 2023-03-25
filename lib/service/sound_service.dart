import 'package:childchamp/utils/sound_utils.dart';
import 'package:just_audio/just_audio.dart';

class SoundService {
  static final player = AudioPlayer();
  static final bgPlayer = AudioPlayer();
  static final alphabetOptionPlayer = AudioPlayer();
  static final alphabetWordPlayer = AudioPlayer();

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

  /// ALPHABET SOUND
  static Future<void> setAlphabetPlayer(String path) async {
    await alphabetOptionPlayer.setAsset(path);
    await alphabetOptionPlayer.setSpeed(0.7);
    alphabetOptionPlayer.play();
  }

  static void stopAlphabetPlayer() {
    alphabetOptionPlayer.stop();
  }

  static void disposeAlphabetPlayer() {
    alphabetOptionPlayer.dispose();
  }

  /// ALPHABET WORD SOUND
  static Future<void> setAlphabetWordPlayer(String path) async {
    await alphabetWordPlayer.setAsset(path);
    alphabetWordPlayer.play();
  }

  static void stopAlphabetWordPlayer() {
    alphabetWordPlayer.stop();
  }

  static void disposeAlphabetWordPlayer() {
    alphabetWordPlayer.dispose();
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
