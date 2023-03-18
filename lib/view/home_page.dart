import 'package:childchamp/dialog/update_version_dialog.dart';
import 'package:childchamp/service/google_ads_service.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:childchamp/utils/const_utils.dart';
import 'package:childchamp/utils/enum_utils.dart';
import 'package:childchamp/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../routs/router_helper.dart';
import '../utils/assets_widget.dart';
import '../utils/champ_assets.dart';
import '../utils/preference_manager_utils.dart';
import '../utils/text_utils.dart';
import '../viewmodel/question_ans_viewmodel.dart';
import '../viewmodel/setting_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool isBackGround = false;
  final questionAnsViewModel = Get.find<QuestionAnsViewModel>();
  late AnimationController lngAnimationController;
  late Animation<double> lngAnimation;
  BannerAd? _bannerAd;

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
    lngAnimation = Tween<double>(
            begin: 0.0,
            end: ConstUtils.deviceType == DeviceType.Phone ? 120.sp : 110.sp)
        .animate(CurvedAnimation(
      parent: lngAnimationController,
      curve: Curves.bounceOut,
    ));
    Future.delayed(const Duration(milliseconds: 500), () {
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
    logs(
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
      logs('Unable to get height of anchored banner.');
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: GoogleAdsService.bannerAdsKey,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          logs('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logs('Anchored adaptive banner failedToLoad: $error');
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
              left: ConstUtils.deviceType == DeviceType.Phone ? 30.sp : 40.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.englishAlphabet);
                    questionAnsViewModel.questionType = QuestionType.English;
                    onAddShow();
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                  },
                  child: AnimationBox(
                    lngAnimation: lngAnimation,
                    img: ChampAssets.alphabet,
                  )),
            ),
            Positioned(
              top: 30.h,
              right: ConstUtils.deviceType == DeviceType.Phone ? 25.sp : 30.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.gujaratiVyanjan);
                    questionAnsViewModel.questionType = QuestionType.Gujrati;
                    onAddShow();
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute());
                  },
                  child: AnimationBox(
                    lngAnimation: lngAnimation,
                    img: ChampAssets.baraKhaDiGujarati,
                  )),
            ),
            Positioned(
              top: ConstUtils.deviceType == DeviceType.Phone
                  ? (30.h + 110.sp)
                  : (30.h + 100.sp),
              right: ConstUtils.deviceType == DeviceType.Phone ? 80.sp : 90.sp,
              left: ConstUtils.deviceType == DeviceType.Phone ? 80.sp : 90.sp,
              child: InkWell(
                  onTap: () {
                    questionAnsViewModel
                        .setQuestionList(TextUtils.hindiVyanjan);
                    questionAnsViewModel.questionType = QuestionType.Hindi;
                    onAddShow();
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
                        size: 15.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _getAdWidget(),
            ),
          ],
        ),
      ),
    );
  }

  void onAddShow() {
    logs('ConstUtils.lanSelectAdsCount:=>${ConstUtils.lanSelectAdsCount}');
    if (ConstUtils.lanSelectAdsCount == 1 ||
        (ConstUtils.lanSelectAdsCount % 3 == 0)) {
      GoogleAdsService.showInterstitialAd();
    }
    ConstUtils.lanSelectAdsCount++;
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
