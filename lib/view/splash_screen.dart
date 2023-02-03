import 'package:childchamp/dialog/update_version_dialog.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/assets_widget.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../routs/router_helper.dart';
import '../utils/champ_assets.dart';
import '../utils/preference_manager_utils.dart';
import '../viewmodel/setting_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController kidsController;
  late AnimationController champController;

  Future<void> animationLogic() async {
    kidsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    champController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    kidsController.forward().whenComplete(() => champController.forward()
      ..whenComplete(() {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Get.offAllNamed(RouteHelper.getHomePageRoute());
          },
        );
      }));
  }

  @override
  void dispose() {
    kidsController.dispose();
    champController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.appWhite,
      child: GetBuilder<SettingsViewModel>(
        initState: (setState) async {
          animationLogic();
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.initVolume = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.volume);
          settingsViewModel.initBgMusic = PreferenceManagerUtils.getPreference(
              PreferenceManagerUtils.bgMusic);
          await SoundService.setBgPlayerPath();
        },
        builder: (settingsViewModel) {
          return Stack(
            children: [
              ChampAssetsWidget(
                imagePath: ChampAssets.splashScreen,
                width: Get.width,
                height: Get.height,
              ),
              KidsTextAnimation(kidsController: kidsController),
              ChampTextAnimation(
                champController: champController,
              ),
            ],
          );
        },
      ),
    );
  }
}

class KidsTextAnimation extends StatelessWidget {
  const KidsTextAnimation({
    Key? key,
    required this.kidsController,
  }) : super(key: key);

  final AnimationController kidsController;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
            Rect.fromLTWH(5.w, -110.sp, 110.sp, 70.sp), screenSize),
        end: RelativeRect.fromSize(
            Rect.fromLTWH(5.w, 12.h, 130.sp, 70.sp), screenSize),
      ).animate(CurvedAnimation(
        parent: kidsController,
        curve: Curves.elasticOut,
      )),
      child: const ChampAssetsWidget(
        imagePath: ChampAssets.kidsImg,
        imageScale: 4.7,
      ),
    );
  }
}

class ChampTextAnimation extends StatelessWidget {
  const ChampTextAnimation({
    Key? key,
    required this.champController,
  }) : super(key: key);

  final AnimationController champController;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
            Rect.fromLTWH(screenSize.width-5.w-110.sp, -170.sp, 160.sp, 70.sp), screenSize),
        end: RelativeRect.fromSize(
            Rect.fromLTWH(screenSize.width-5.w-190.sp, 22.h, 200.sp, 90.sp), screenSize),
      ).animate(CurvedAnimation(
        parent: champController,
        curve: Curves.elasticOut,
      )),
      child: const ChampAssetsWidget(
        imagePath: ChampAssets.champImg,
        imageScale: 4.7,
      ),
    );
  }
}
