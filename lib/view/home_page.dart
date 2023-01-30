import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:childchamp/utils/enum_utils.dart';
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

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final questionAnsViewModel = Get.find<QuestionAnsViewModel>();

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
                child: ChampAssetsWidget(
                  imagePath: ChampAssets.alphabet,
                  height: 120.sp,
                  width: 120.sp,
                ),
              ),
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
                child: ChampAssetsWidget(
                  imagePath: ChampAssets.baraKhaDiGujarati,
                  height: 120.sp,
                  width: 120.sp,
                ),
              ),
            ),
            Positioned(
              top: (30.h + 110.sp),
              right: 80.sp,
              left: 80.sp,
              child: InkWell(
                onTap: () {
                  questionAnsViewModel.setQuestionList(TextUtils.hindiVyanjan);
                  questionAnsViewModel.questionType = QuestionType.Hindi;
                  Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                },
                child: ChampAssetsWidget(
                  imagePath: ChampAssets.baraKhaDiHindi,
                  height: 120.sp,
                  width: 120.sp,
                ),
              ),
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
