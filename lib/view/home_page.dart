import 'package:childchamp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../routs/router_helper.dart';
import '../utils/assets_widget.dart';
import '../utils/champ_assets.dart';
import '../utils/preference_manager_utils.dart';
import '../viewmodel/setting_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              top: 200.sp,
              left: 30.sp,
              child: InkWell(
                onTap: () =>
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute()),
                child: ChampAssetsWidget(
                  imagePath: ChampAssets.alphabet,
                  height: 120.sp,
                  width: 120.sp,
                ),
              ),
            ),
            Positioned(
              top: 200.sp,
              right: 25.sp,
              child: InkWell(
                onTap: () =>
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute()),
                child: ChampAssetsWidget(
                  imagePath: ChampAssets.baraKhaDiGujarati,
                  height: 120.sp,
                  width: 120.sp,
                ),
              ),
            ),
            Positioned(
              top: 325.sp,
              right: 80.sp,
              left: 80.sp,
              child: InkWell(
                onTap: () =>
                    Get.toNamed(RouteHelper.getQuestionAnsScreenRoute()),
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
                      settingsViewModel.music = !settingsViewModel.music;
                      await PreferenceManagerUtils.setPreference(
                          PreferenceManagerUtils.music,
                          settingsViewModel.music);
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
                        settingsViewModel.music
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
