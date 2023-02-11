import 'package:childchamp/utils/assets_widget.dart';
import 'package:childchamp/utils/champ_assets.dart';
import 'package:childchamp/utils/const_utils.dart';
import 'package:childchamp/utils/enum_utils.dart';
import 'package:childchamp/utils/extension_utils.dart';
import 'package:childchamp/viewmodel/question_ans_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:childchamp/utils/extension_utils.dart';

Future<void> ansAnimationDialog(
    {required bool rightAns, bool? complete}) async {
  await Get.dialog(
    ShowResultAnimation(rightAns: rightAns, complete: complete),
    barrierDismissible: false,
  );
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
                      imageScale: ConstUtils.deviceType==DeviceType.Phone?1.5.sp:0.4.sp,
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
