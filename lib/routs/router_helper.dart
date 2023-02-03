import 'package:childchamp/routs/router_constant.dart';
import 'package:childchamp/view/home_page.dart';
import 'package:childchamp/view/splash_screen.dart';
import 'package:get/get.dart';

import '../view/question_ans_screen.dart';

class RouteHelper {
  static String getSplashRoute() => RouterConstant.splash;
  static String getHomePageRoute() => RouterConstant.home;
  static String getQuestionAnsScreenRoute() => RouterConstant.questionAnsBoard;

  static List<GetPage> routes = [
    GetPage(name: RouterConstant.splash, page: () =>  SplashScreen()),
    GetPage(name: RouterConstant.home, page: () => HomePage()),
    GetPage(
        name: RouterConstant.questionAnsBoard, page: () => QuestionAnsScreen())
  ];
}
