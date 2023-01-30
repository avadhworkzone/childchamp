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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Get.offAllNamed(RouteHelper.getHomePageRoute());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.appWhite,
      child: GetBuilder<SettingsViewModel>(
        initState: (setState) async {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.initVolume = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.volume);
          settingsViewModel.initBgMusic = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.bgMusic);
          await SoundService.setBgPlayerPath();
          if(settingsViewModel.bgMusic){
            SoundService.playBgPlayer();
          }
        },
        builder: (settingsViewModel) {
          return Lottie.asset(ChampAssets.splashAnimation);
        },
      ),
    );
  }
}
