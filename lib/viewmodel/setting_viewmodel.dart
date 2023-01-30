import 'package:get/get.dart';

class SettingsViewModel extends GetxController {
  ///SET FOR VOLUME.......
  bool _volume = true;
  bool get volume => _volume;
  set initVolume(bool value) {
    _volume = value;
  }

  set volume(bool value) {
    _volume = value;
    update();
  }

  ///SET FOR MUSIC
  bool _bgMusic = true;
  bool get bgMusic => _bgMusic;
  set initBgMusic(bool value) {
    _bgMusic = value;
  }

  set bgMusic(bool value) {
    _bgMusic = value;
    update();
  }
}
