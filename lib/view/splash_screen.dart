import 'package:childchamp/dialog/update_version_dialog.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../routs/router_helper.dart';
import '../utils/champ_assets.dart';
import '../utils/preference_manager_utils.dart';
import '../viewmodel/setting_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  bool isBackGround = false;
  final settingsViewModel = Get.find<SettingsViewModel>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offAllNamed(RouteHelper.getHomePageRoute());
      },
    );
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      isBackGround = true;
      stopBgMusic();
    } else if (state == AppLifecycleState.resumed) {
      isBackGround = false;
      playBgMusic();
    }
  }

  void playBgMusic() {
    print(
        'isBackGround :=>$isBackGround settingsViewModel.bgMusic:=>${settingsViewModel.bgMusic}');
    if (settingsViewModel.bgMusic && !isBackGround) {
      SoundService.playBgPlayer();
    }
  }

  void stopBgMusic() {
    SoundService.stopBgPlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.appWhite,
      child: GetBuilder<SettingsViewModel>(
        initState: (setState) async {
          settingsViewModel.initVolume = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.volume);
          settingsViewModel.initBgMusic = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.bgMusic);
          await SoundService.setBgPlayerPath();
          playBgMusic();
        },
        builder: (settingsViewModel) {
          return Lottie.asset(ChampAssets.splashAnimation);
        },
      ),
    );
  }
}
