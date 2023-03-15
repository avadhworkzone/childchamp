import 'package:childchamp/utils/const_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TextUtils {
  static const appName = "Kids Champ";
  static const updateMsg =
      'A new version is available. Update the app to continue.';
  static String appVersion = "";

  static getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    // print("APP BUILD APP ${appName}");
    logs("APP BUILD APP $packageInfo");
    // print("APP BUILD APP ${packageInfo.buildNumber}");
    // print("APP BUILD APP ${appVersion}");
    // buildNumber = packageInfo.buildNumber;
  }

  static const hindiSwar = [
    'अ',
    'आ',
    'इ',
    'ई',
    'उ',
    'ऊ',
    'ऋ',
    'ए',
    'ऐ',
    'ओ',
    'औ'
  ];
  static const hindiVyanjan = [
    'क',
    'ख',
    'ग',
    'घ',
    'च',
    'छ',
    'ज',
    'झ',
    'ट',
    'ठ',
    'ड',
    'ढ़',
    'ण',
    'त',
    'थ',
    'द',
    'ध',
    'न',
    'प',
    'फ',
    'ब',
    'भ',
    'म',
    'य',
    'र',
    'ल',
    'व',
    'श',
    'ष',
    'स',
    'ह',
    'क्ष',
    'ज्ञ'
  ];

  static const gujaratiSwar = [
    'અ',
    'આ',
    'ઇ',
    'ઈ',
    'ઉ',
    'ઊ',
    'ૠ',
    'એ',
    'ઐ',
    'ઓ',
    'ઔ',
    'અં',
    'અઃ'
  ];
  static const gujaratiVyanjan = [
    'ક',
    'ખ',
    'ગ',
    'ઘ',
    'ચ',
    'છ',
    'જ',
    'ઝ',
    'ટ',
    'ઠ',
    'ડ',
    'ઢ',
    'ણ',
    'ત',
    'થ',
    'દ',
    'ધ',
    'ન',
    'પ',
    'ફ',
    'બ',
    'ભ',
    'મ',
    'ય',
    'ર',
    'લ',
    'વ',
    'શ',
    'ષ',
    'સ',
    'હ',
    'ક્ષ',
    'જ્ઞ'
  ];

  static const englishAlphabet = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
}
