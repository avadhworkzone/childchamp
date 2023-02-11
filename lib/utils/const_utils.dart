import 'package:get/get.dart';

import 'enum_utils.dart';

class ConstUtils {
  static DeviceType deviceType = DeviceType.Phone;

  static void setDeviceType() {
    deviceType = Get.height > 1000 ? DeviceType.Tablet : DeviceType.Phone;
  }

  static String getGrade(num percent) {
    if (percent > 80) {
      return 'A';
    } else if (percent > 60) {
      return 'B';
    } else if (percent > 40) {
      return 'C';
    } else if (percent > 32) {
      return 'D';
    } else {
      return 'F';
    }
  }

  static num getPercentage({required int winCount, required int totalMark}) {
    return winCount * 100 / totalMark;
  }
}
