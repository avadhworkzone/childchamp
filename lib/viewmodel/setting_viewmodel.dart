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
  bool _music = true;
  bool get music => _music;
  set initMusic(bool value) {
    _music = value;
  }

  set music(bool value) {
    _music = value;
    update();
  }
}
