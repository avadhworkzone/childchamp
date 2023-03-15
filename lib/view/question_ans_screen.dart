import 'dart:math' as math;

import 'package:childchamp/dialog/ans_animation_dialog.dart';
import 'package:childchamp/dialog/final_result_dialog.dart';
import 'package:childchamp/dialog/setting_dialog.dart';
import 'package:childchamp/service/google_ads_service.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/champ_text.dart';
import 'package:childchamp/utils/const_utils.dart';
import 'package:childchamp/utils/enum_utils.dart';
import 'package:childchamp/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/assets_widget.dart';
import '../utils/champ_assets.dart';
import '../utils/color_utils.dart';
import '../utils/preference_manager_utils.dart';
import '../viewmodel/question_ans_viewmodel.dart';

class QuestionAnsScreen extends StatefulWidget {
  QuestionAnsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnsScreen> createState() => _QuestionAnsScreenState();
}

class _QuestionAnsScreenState extends State<QuestionAnsScreen>
    with WidgetsBindingObserver {
  final questionAnsViewModel = Get.find<QuestionAnsViewModel>();
  bool isBackGround = false;

  BannerAd? _bannerAd;

  @override
  void initState() {
    questionAnsViewModel.clearQA();
    managedOption();
    WidgetsBinding.instance.addObserver(this);
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
        'isBackGround :=>$isBackGround settingsViewModel.bgMusic:=>${PreferenceManagerUtils.getPreference(PreferenceManagerUtils.bgMusic)}');
    if (PreferenceManagerUtils.getPreference(PreferenceManagerUtils.bgMusic) &&
        !isBackGround) {
      SoundService.playBgPlayer();
    }
  }

  void stopBgMusic() {
    SoundService.stopBgPlayer();
  }

  /// ================================== BANNER ADS CODE =============================== ///

  @override
  void didChangeDependencies() {
    logs('didChangeDependencies CALL --------------------');
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() async {
    await _bannerAd?.dispose();
    setState(() {
      _bannerAd = null;
    });
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            // ignore: use_build_context_synchronously
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: GoogleAdsService.bannerAdsKey,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _bannerAd!.load();
  }

  Widget _getAdWidget() {
    if (_bannerAd == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 60,
      width: Get.width,
      child: AdWidget(
        key: ValueKey(_bannerAd?.adUnitId ?? '0'),
        ad: _bannerAd!,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorUtils.appWhite,
      child: GetBuilder<QuestionAnsViewModel>(
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
                  top: (28.h + 95.sp) + 3.h,
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
                  top: (28.h + 95.sp) + 3.h,
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
                    height: 30.h,
                    padding: EdgeInsets.only(top: 6.h),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: const AssetImage(ChampAssets.boyWithBoard),
                    )),
                    child: ChampText(
                      questionAnsViewModel.questionList[
                              questionAnsViewModel.selectedOptionIndex]
                          .toUpperCase(),
                      fontSize: 10.h,
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
                  top: 5.h,
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
                        onTap: () => settingDialog(),
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
                            Icons.settings,
                            color: ColorUtils.appWhite,
                            size: 15.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: _getAdWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  onOptionTap() async {
    if (questionAnsViewModel.selectedOptionIndex ==
        questionAnsViewModel.questionList.length - 1) {
      await finalResultDialog();
      questionAnsViewModel.clearQA();
      managedOption();
      return;
    }
    onAddShow();
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

  void onAddShow() {
    print('ConstUtils.queAdsCount:=>${ConstUtils.queAdsCount}');
    if ((ConstUtils.queAdsCount % 10 == 0)) {
      GoogleAdsService.showInterstitialAd();
    }
    ConstUtils.queAdsCount++;
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
              // SoundService.setPlayer(SoundUtils.winSound);
            }
          } else {
            questionAnsViewModel.lostCount++;
            if (PreferenceManagerUtils.getPreference(
                    PreferenceManagerUtils.volume) ==
                true) {
              // SoundService.setPlayer(SoundUtils.lostSound);
            }
          }

          await ansAnimationDialog(
            rightAns: queId == optionId ? true : false,
          );

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
