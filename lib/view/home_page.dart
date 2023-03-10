import 'package:childchamp/dialog/final_result_dialog.dart';
import 'package:childchamp/dialog/update_version_dialog.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/champ_text.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:childchamp/utils/enum_utils.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../routs/router_helper.dart';
import '../utils/assets_widget.dart';
import '../utils/champ_assets.dart';
import '../utils/preference_manager_utils.dart';
import '../utils/text_utils.dart';
import '../viewmodel/question_ans_viewmodel.dart';
import '../viewmodel/setting_viewmodel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool isBackGround = false;
  final questionAnsViewModel = Get.find<QuestionAnsViewModel>();
  late AnimationController lngAnimationController;
  late Animation<double> lngAnimation;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _selectingLangAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAppVersion();
      playBgMusic();
    });
    super.initState();
  }

  _selectingLangAnimation() {
    lngAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    lngAnimation =
        Tween<double>(begin: 0.0, end: 120.sp).animate(CurvedAnimation(
      parent: lngAnimationController,
      curve: Curves.bounceOut,
    ));
    Future.delayed(Duration(milliseconds: 500), () {
      lngAnimationController.forward();
    });
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
        'isBackGround :=>$isBackGround settingsViewModel.bgMusic:=>${PreferenceManagerUtils.getPreference(PreferenceManagerUtils.bgMusic)}');
    if (PreferenceManagerUtils.getPreference(PreferenceManagerUtils.bgMusic) &&
        !isBackGround) {
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
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: ChampAssetsWidget(
                imagePath: ChampAssets.homeBg,
                boxFit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 30.h,
              left: 30.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.englishAlphabet);
                    questionAnsViewModel.questionType = QuestionType.English;
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                  },
                  child: AnimationBox(
                    lngAnimation: lngAnimation,
                    img: ChampAssets.alphabet,
                  )),
            ),
            Positioned(
              top: 30.h,
              right: 25.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.gujaratiVyanjan);
                    questionAnsViewModel.questionType = QuestionType.Gujrati;
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                  },
                  child: AnimationBox(
                    lngAnimation: lngAnimation,
                    img: ChampAssets.baraKhaDiGujarati,
                  )),
            ),
            Positioned(
              top: (30.h + 110.sp),
              right: 80.sp,
              left: 80.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.hindiVyanjan);
                    questionAnsViewModel.questionType = QuestionType.Hindi;
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                  },
                  child: AnimationBox(
                    lngAnimation: lngAnimation,
                    img: ChampAssets.baraKhaDiHindi,
                  )),
            ),
            Positioned(
              top: 35.sp,
              right: 10.sp,
              child: GetBuilder<SettingsViewModel>(
                builder: (settingsViewModel) {
                  return InkWell(
                    onTap: () async {
                      settingsViewModel.bgMusic = !settingsViewModel.bgMusic;
                      await PreferenceManagerUtils.setPreference(
                          PreferenceManagerUtils.bgMusic,
                          settingsViewModel.bgMusic);
                      if (!settingsViewModel.bgMusic) {
                        SoundService.stopBgPlayer();
                      } else {
                        SoundService.resumeBgPlayer();
                      }
                    },
                    child: Container(
                      height: 40.sp,
                      width: 40.sp,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.sp,
                      ),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ChampAssets.squareSolid))),
                      child: Icon(
                        settingsViewModel.bgMusic
                            ? Icons.music_note
                            : Icons.music_off,
                        color: ColorUtils.appWhite,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimationBox extends StatelessWidget {
  const AnimationBox({
    Key? key,
    required this.lngAnimation,
    required this.img,
  }) : super(key: key);

  final Animation<double> lngAnimation;
  final String img;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: lngAnimation,
      builder: (context, child) {
        return ChampAssetsWidget(
          imagePath: img,
          height: lngAnimation.value,
          width: lngAnimation.value,
        );
      },
    );
  }
}
