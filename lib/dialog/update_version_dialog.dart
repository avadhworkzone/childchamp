import 'dart:io';

import 'package:childchamp/utils/assets_widget.dart';
import 'package:childchamp/utils/champ_assets.dart';
import 'package:childchamp/utils/champ_text.dart';
import 'package:childchamp/utils/const_utils.dart';
import 'package:childchamp/utils/text_utils.dart';
import 'package:childchamp/viewmodel/setting_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';
import 'package:childchamp/utils/extension_utils.dart';

Future<void> checkAppVersion() async {
  final snapShot = await FirebaseFirestore.instance
      .collection('AppVersion')
      .doc('AppVersion')
      .get();
  if (snapShot.exists) {
    final doc = snapShot.data();

    String appVersion = "";
    int newVersion = 0;
    int currentVersion = int.parse(TextUtils.appVersion.replaceAll('.', ''));
    if (Platform.isAndroid) {
      if (doc!.containsKey('android')) {
        appVersion = doc['android'].replaceAll('.', '');
        newVersion = int.parse(appVersion);
      }
    } else {
      if (doc!.containsKey('ios')) {
        appVersion = doc['ios'].replaceAll('.', '');
        newVersion = int.parse(appVersion);
      }
    }
    logs('NEW VERSION : $newVersion CURRENT VERSION :$currentVersion');
    if (newVersion > currentVersion) {
      updateVersionDialog();
    }
  } else {
    final body = Platform.isAndroid
        ? {"android": TextUtils.appVersion}
        : {'ios': TextUtils.appVersion};
    FirebaseFirestore.instance
        .collection('AppVersion')
        .doc('AppVersion')
        .set(body, SetOptions(merge: true));
  }
}

void updateVersionDialog() {
  Get.dialog(const SettingDialog(), barrierDismissible: false);
}

class SettingDialog extends StatelessWidget {
  const SettingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Material(
        color: Colors.transparent,
        child: GetBuilder<SettingsViewModel>(
          builder: (settingsViewModel) {
            return Stack(
              children: [
                Positioned(
                  top: 30.h,
                  bottom: 35.h,
                  right: 0,
                  left: 0,
                  child: const ChampAssetsWidget(
                    imagePath: ChampAssets.updateDialogBg,
                  ),
                ),
                Positioned(
                  top: 40.h,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.sp),
                    child: ChampText(
                      TextUtils.updateMsg,
                      textAlign: TextAlign.center,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff6B2D33),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 35.h - (3.2.w / 2)),
                    child: InkWell(
                      onTap: () {
                        OpenStore.instance.open(
                          appStoreId: '', // AppStore id of your app
                          androidAppBundleId:
                              'com.kids.childchamp', // Android app bundle package name
                        );
                      },
                      child: ChampAssetsWidget(
                        imagePath: ChampAssets.updateBtn,
                        imageScale: 0.8.w,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
