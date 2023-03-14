import 'dart:async';

import 'package:childchamp/routs/router_helper.dart';
import 'package:childchamp/service/google_ads_service.dart';
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
import 'package:childchamp/utils/extension_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const _kShouldTestAsyncErrorOnInit = false;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await GetStorage.init();
    await TextUtils.getAppVersion();
    MobileAds.instance.initialize();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(MyApp());
  }, (error, stackTrace) {
    print('ERROR :=>> $error');
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
    init();
    super.initState();
  }

  Future<void> init() async {
    initializeFlutterFireFuture = _initializeFlutterFire();
    GoogleAdsService.getAdsKeyFromFirebase();
    // GoogleAdsService.loadAppOpenAd();
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
  void dispose() {
    GoogleAdsService.disposeAdsController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrained) {
        if (constrained.maxHeight == 0) {
          return const Material();
        }
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
      },
    );
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
