import 'package:childchamp/routs/router_helper.dart';
import 'package:childchamp/service/sound_service.dart';
import 'package:childchamp/utils/assets_widget.dart';
import 'package:childchamp/utils/champ_assets.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:childchamp/utils/preference_manager_utils.dart';
import 'package:childchamp/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:childchamp/utils/extension_utils.dart';

void settingDialog() {
  Get.dialog(const SettingDialog());
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
                      child: Icon(
                        Icons.close_rounded,
                        color: ColorUtils.appWhite,
                        size: 15.sp,
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
                            size: 15.sp,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          settingsViewModel.bgMusic =
                              !settingsViewModel.bgMusic;
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
                            settingsViewModel.bgMusic
                                ? Icons.music_note
                                : Icons.music_off,
                            color: ColorUtils.appWhite,
                            size: 15.sp,
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
                          child: Icon(
                            Icons.menu,
                            color: ColorUtils.appWhite,
                            size: 15.sp,
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
