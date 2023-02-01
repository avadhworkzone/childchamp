class ConstUtils {
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
