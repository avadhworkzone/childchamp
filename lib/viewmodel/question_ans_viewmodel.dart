import 'package:get/get.dart';

class QuestionAnsViewModel extends GetxController {
  bool _isResult = false;

  bool get isResult => _isResult;

  set initIsResult(bool value) {
    _isResult = value;
  }

  set isResult(bool value) {
    _isResult = value;
    update();
  }
}
