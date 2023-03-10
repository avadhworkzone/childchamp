import 'dart:async';

import 'package:childchamp/routs/router_helper.dart';
import 'package:childchamp/utils/text_utils.dart';
import 'package:childchamp/view/home_page.dart';
import 'package:childchamp/viewmodel/question_ans_viewmodel.dart';
import 'package:childchamp/viewmodel/setting_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

const _kShouldTestAsyncErrorOnInit = false;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await GetStorage.init();
    await TextUtils.getAppVersion();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> initializeFlutterFireFuture;

  @override
  void initState() {
    initializeFlutterFireFuture = _initializeFlutterFire();

    super.initState();
  }

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  Future<void> _initializeFlutterFire() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }
    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

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
        // home: HomePage(),
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


class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCREEN 1'),
      ),
      body: FloatingActionButton(
        onPressed: () {
          Get.to(() => Screen2());
        },
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCREEN 2'),
      ),
      body: FloatingActionButton(
        onPressed: () async {
          final status = await Get.to(() => Screen3());
          if (status) {
            Get.dialog(SizedBox(
              height: Get.height,
              width: Get.width,
              child: Stack(
                children: [
                  Container(
                    color: Colors.green,
                    height: Get.height,
                    width: Get.width,
                  ),
                  AnimatedContainer(
                    color: Colors.red,
                    transform: Matrix4.translationValues(
                        Get.width - 30.w, Get.height - 30.h, 0)
                      ..scale(0.3),
                    duration: Duration(seconds: 2),
                  ),
                ],
              ),
            ));
          }
          print('STATUS :=>$status');
        },
      ),
    );
  }
}

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  bool isAnimated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCREEN 3'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAnimated = !isAnimated;
          });
        },
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            Container(
              color: Colors.green,
              height: Get.height,
              width: Get.width,
            ),
            AnimatedContainer(
              color: Colors.red,
              transform: Matrix4.translationValues(
                  !isAnimated ? 0 : Get.width - 40.w,
                  !isAnimated ? 0 : Get.height - 45.h,
                  0)
                ..scale(!isAnimated?1.0:0.3),
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            ),
          ],
        ),
      ),
      // body: Column(
      //   children: [
      //     TextButton(
      //         onPressed: () {
      //           Get.back(result: true);
      //         },
      //         child: Text('Call Started')),
      //     TextButton(
      //         onPressed: () {
      //           Get.back(result: false);
      //         },
      //         child: Text('Call Ended')),
      //   ],
      // )
    );
  }
}
