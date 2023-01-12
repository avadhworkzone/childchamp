import 'package:childchamp/routs/router_helper.dart';
import 'package:childchamp/utils/text_utils.dart';
import 'package:childchamp/view/home_page.dart';
import 'package:childchamp/viewmodel/question_ans_viewmodel.dart';
import 'package:childchamp/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: TextUtils.appName,
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteHelper.getSplashRoute(),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.fadeIn,
        scrollBehavior: MyBehavior(),
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
        home: const HomePage(),
      );
    });
  }

  SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  QuestionAnsViewModel questionAnsViewModel = Get.put(QuestionAnsViewModel());
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
