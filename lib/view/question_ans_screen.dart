import 'dart:math' as math;

import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/champ_text.dart';
import 'package:childchamp/utils/enum_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../routs/router_helper.dart';
import '../utils/assets_widget.dart';
import '../utils/champ_assets.dart';
import '../utils/color_utils.dart';
import '../utils/preference_manager_utils.dart';
import '../viewmodel/question_ans_viewmodel.dart';
import '../viewmodel/setting_viewmodel.dart';

class QuestionAnsScreen extends StatelessWidget {
  QuestionAnsScreen({Key? key}) : super(key: key);

  final questionAnsViewModel = Get.find<QuestionAnsViewModel>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.appWhite,
      child: GetBuilder<QuestionAnsViewModel>(
        initState: (setState) {
          questionAnsViewModel.clearQA();
          managedOption();
        },
        builder: (questionAnsViewModel) {
          return SizedBox(
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
                    imagePath: ChampAssets.qaBoard,
                  ),
                ),

                ///OPTION 1.....
                Positioned(
                  top: 28.h,
                  left: 50.sp,
                  child: RoundedOptionWidget(
                    optionId: questionAnsViewModel.optionList.isEmpty
                        ? 0
                        : questionAnsViewModel.optionList[0],
                    selectAns: onOptionTap,
                  ),
                ),

                ///OPTION 2.....
                Positioned(
                  top: 28.h,
                  right: 50.sp,
                  child: RoundedOptionWidget(
                    selectAns: onOptionTap,
                    optionId: questionAnsViewModel.optionList.length < 2
                        ? 0
                        : questionAnsViewModel.optionList[1],
                  ),
                ),

                ///OPTION 3.....
                Positioned(
                  top: (28.h + 95.sp) + 30.sp,
                  left: 50.sp,
                  child: RoundedOptionWidget(
                    selectAns: onOptionTap,
                    optionId: questionAnsViewModel.optionList.length < 3
                        ? 0
                        : questionAnsViewModel.optionList[2],
                  ),
                ),

                ///OPTION 4.....
                Positioned(
                  top: (28.h + 95.sp) + 30.sp,
                  right: 50.sp,
                  child: RoundedOptionWidget(
                    selectAns: onOptionTap,
                    optionId: questionAnsViewModel.optionList.length < 4
                        ? 0
                        : questionAnsViewModel.optionList[3],
                  ),
                ),

                ///QUESTION BOARD...
                Positioned(
                  bottom: 0.sp,
                  right: 0.sp,
                  left: 0.sp,
                  child: Container(
                    height: 180.sp,
                    padding: EdgeInsets.only(top: 40.sp),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: const AssetImage(ChampAssets.boyWithBoard),
                            scale: 2.5.sp)),
                    child: ChampText(
                      questionAnsViewModel.questionList[
                              questionAnsViewModel.selectedOptionIndex]
                          .toUpperCase(),
                      fontSize: 50.sp,
                      textAlign: TextAlign.center,
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 0.sp,
                //   right: 0.sp,
                //   left: 0.sp,
                //   child: ChampAssetsWidget(
                //     imagePath: ChampAssets.boyWithBoard,
                //     imageScale: 2.5.sp,
                //   ),
                // ),
                // Positioned(
                //   bottom: 85.sp,
                //   right: 120.sp,
                //   left: 120.sp,
                //   child: ChampText(
                //     // "A",
                //     // "ક",
                //     "क",
                //     fontSize: 50.sp,
                //     textAlign: TextAlign.center,
                //     color:
                //         Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                //             .withOpacity(1.0),
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Positioned(
                  top: 40.sp,
                  left: 20.sp,
                  child: Row(
                    children: [
                      Container(
                        height: 50.sp,
                        width: 50.sp,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.sp,
                        ),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(ChampAssets.roundedSolid))),
                        child: ChampText(
                          "Win\n${questionAnsViewModel.winCount}",
                          textAlign: TextAlign.center,
                          fontSize: 8.sp,
                          color: ColorUtils.appWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 15.sp,
                      ),
                      Container(
                        height: 50.sp,
                        width: 50.sp,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.sp,
                        ),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(ChampAssets.roundedSolid))),
                        child: ChampText(
                          "Lost\n${questionAnsViewModel.lostCount}",
                          textAlign: TextAlign.center,
                          fontSize: 8.sp,
                          color: ColorUtils.appWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 100.sp,
                      ),
                      InkWell(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => const SettingDialog()),
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
                          child: const Icon(
                            Icons.settings,
                            color: ColorUtils.appWhite,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  onOptionTap() {
    if (questionAnsViewModel.selectedOptionIndex ==
        questionAnsViewModel.questionList.length - 1) {
      Get.dialog(
        ShowResultAnimation(
          rightAns: false,
          complete: true,
        ),
        barrierDismissible: false,
      );
      return;
    }
    questionAnsViewModel.selectedOptionIndex++;
    managedOption();
  }

  ///GENERATE RANDOM OPTION AND SET ONE ANS.
  void managedOption() {
    List<int> tempOptionList = [];
    for (int optionIndex = 0; optionIndex < 1000; optionIndex++) {
      if (tempOptionList.length == 4) {
        break;
      }
      final optionIndex =
          math.Random().nextInt(questionAnsViewModel.questionList.length - 1);
      if (!tempOptionList.contains(optionIndex)) {
        tempOptionList.add(optionIndex);
      }
    }
    if (!tempOptionList.contains(questionAnsViewModel.selectedOptionIndex)) {
      tempOptionList.removeAt(0);
      tempOptionList.insert(
          math.Random().nextInt(3), questionAnsViewModel.selectedOptionIndex);
    }
    questionAnsViewModel.setOptionList(tempOptionList);
  }
}

class RoundedOptionWidget extends StatelessWidget {
  const RoundedOptionWidget({
    Key? key,
    required this.selectAns,
    required this.optionId,
  }) : super(key: key);
  final VoidCallback selectAns;
  final int optionId;

  @override
  Widget build(BuildContext context) {
    double imgHeightWidth = 95.sp;

    return Container(
      height: imgHeightWidth,
      width: imgHeightWidth,
      padding: EdgeInsets.fromLTRB(5.sp, 18.sp, 5.sp, 18.sp),

      // padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 27.sp),
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(ChampAssets.roundedFrame))),
      child: InkWell(
        onTap: () async {
          final questionAnsViewModel = Get.find<QuestionAnsViewModel>();
          final queId = questionAnsViewModel.selectedOptionIndex;
          if (queId == optionId) {
            questionAnsViewModel.winCount++;
            if (PreferenceManagerUtils.getPreference(
                    PreferenceManagerUtils.volume) ==
                true) {
              SoundService.setPlayer('assets/sound/winnersound.mp3');
            }
          } else {
            questionAnsViewModel.lostCount++;
            if (PreferenceManagerUtils.getPreference(
                    PreferenceManagerUtils.volume) ==
                true) {
              SoundService.setPlayer('assets/sound/lostsound.mp3');
            }
          }

          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ShowResultAnimation(
                    rightAns: queId == optionId ? true : false,
                  ));
          // selectedOptionIndex.value++;
          selectAns();
        },
        child: GetBuilder<QuestionAnsViewModel>(builder: (con) {
          return ChampAssetsWidget(
            imagePath: con.questionType == QuestionType.English
                ? 'assets/images/english/eng${optionId + 1}.png'
                : con.questionType == QuestionType.Hindi
                    ? 'assets/images/hindi/hin${optionId + 1}.png'
                    : 'assets/images/gujrati/guj${optionId + 1}.png',
            imageScale: 1.5.sp,
            boxFit: BoxFit.contain,
          );
        }),
      ),
    );
  }
}

class SettingDialog extends StatelessWidget {
  const SettingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<SettingsViewModel>(
        builder: (settingsViewModel) {
          return InkWell(
            onTap: () => Get.back(),
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  bottom: 35.h,
                  right: 0,
                  left: 0,
                  child: const ChampAssetsWidget(
                    imagePath: ChampAssets.settingDialogBg,
                  ),
                ),
                Positioned(
                  bottom: 35.h,
                  right: 130.sp,
                  left: 130.sp,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 50.sp,
                      width: 50.sp,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.sp,
                      ),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ChampAssets.roundedSolid))),
                      child: const Icon(
                        Icons.close_rounded,
                        color: ColorUtils.appWhite,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 42.h,
                  right: 30.sp,
                  left: 40.sp,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          settingsViewModel.volume = !settingsViewModel.volume;
                          await PreferenceManagerUtils.setPreference(
                              PreferenceManagerUtils.volume,
                              settingsViewModel.volume);
                        },
                        child: Container(
                          height: 50.sp,
                          width: 50.sp,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.sp,
                          ),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ChampAssets.roundedSolid))),
                          child: Icon(
                            settingsViewModel.volume
                                ? Icons.volume_up
                                : Icons.volume_off,
                            color: ColorUtils.appWhite,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          settingsViewModel.music = !settingsViewModel.music;
                          await PreferenceManagerUtils.setPreference(
                              PreferenceManagerUtils.music,
                              settingsViewModel.music);
                        },
                        child: Container(
                          height: 50.sp,
                          width: 50.sp,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.sp,
                          ),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ChampAssets.roundedSolid))),
                          child: Icon(
                            settingsViewModel.music
                                ? Icons.music_note
                                : Icons.music_off,
                            color: ColorUtils.appWhite,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Get.offAllNamed(RouteHelper.getHomePageRoute()),
                        child: Container(
                          height: 50.sp,
                          width: 50.sp,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.sp,
                          ),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ChampAssets.roundedSolid))),
                          child: const Icon(
                            Icons.menu,
                            color: ColorUtils.appWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShowResultAnimation extends StatelessWidget {
  ShowResultAnimation({Key? key, required this.rightAns, this.complete})
      : super(key: key);
  final bool rightAns;
  bool? complete = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GetBuilder<QuestionAnsViewModel>(
          initState: (setState) {
            Future.delayed(const Duration(seconds: 4), () {
              Get.back();
            });
          },
          builder: (questionAnsViewModel) {
            return Center(
              child: Animate()
                  .custom(
                    duration: const Duration(seconds: 4),
                    begin: 10,
                    end: 0,
                    builder: (_, value, __) => ChampAssetsWidget(
                      imagePath: complete == true
                          ? ChampAssets.finishAnimation
                          : rightAns
                              ? ChampAssets.rightAnsAnimation
                              : ChampAssets.wrongAnsAnimation,
                      imageScale: 1.5.sp,
                    ),
                  )
                  .fadeOut(),
            );
          },
        ),
      ),
    );
  }
}