import 'package:childchamp/utils/enum_utils.dart';
import 'package:get/get.dart';

class QuestionAnsViewModel extends GetxController {
  QuestionType _questionType = QuestionType.English;

  QuestionType get questionType => _questionType;

  set questionType(QuestionType value) {
    _questionType = value;
    update();
  }

  // bool _isResult = false;
  //
  // bool get isResult => _isResult;
  //
  // set initIsResult(bool value) {
  //   _isResult = value;
  // }
  //
  // set isResult(bool value) {
  //   _isResult = value;
  //   update();
  // }

  List<String> questionList = [];

  void setQuestionList(List<String> qList) {
    questionList = qList;
    update();
  }

  int _selectedOptionIndex = 0;

  int get selectedOptionIndex => _selectedOptionIndex;

  set selectedOptionIndex(int value) {
    _selectedOptionIndex = value;
    update();
  }

  List<int> _optionList = <int>[];

  List<int> get optionList => _optionList;

  void setOptionList(List<int> value) {
    _optionList = value;
    update();
  }

  ///CLEAR QA
  void clearQA() {
    _selectedOptionIndex = 0;
    _winCount = 0;
    _lostCount = 0;
    _optionList.clear();
  }

  int _winCount = 0;

  int get winCount => _winCount;

  set winCount(int value) {
    _winCount = value;
    update();
  }

  int _lostCount = 0;

  int get lostCount => _lostCount;

  set lostCount(int value) {
    _lostCount = value;
    update();
  }
}
