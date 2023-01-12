import 'package:get_storage/get_storage.dart';

class PreferenceManagerUtils {
  static GetStorage getStorage = GetStorage();

  static String volume = "volume";
  static String music = "music";

  ///SET BOOL VALUE....
  ///isVolume
  static Future setPreference(String preferenceKey, bool value) async {
    await getStorage.write(preferenceKey, value);
  }

  static bool getPreference(String preferenceKey) {
    return getStorage.read(preferenceKey) ?? true;
  }
}
