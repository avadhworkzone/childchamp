import 'package:childchamp/utils/assets_widget.dart';
import 'package:childchamp/utils/champ_assets.dart';
import 'package:childchamp/utils/champ_text.dart';
import 'package:childchamp/utils/color_utils.dart';
import 'package:childchamp/utils/const_utils.dart';
import 'package:childchamp/viewmodel/question_ans_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Future<dynamic> finalResultDialog() async {
  await Get.dialog(
    const ResultDialog(),
    barrierDismissible: false,
  );
}

class ResultDialog extends StatelessWidget {
  const ResultDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<QuestionAnsViewModel>(
        builder: (con) {
          return SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                Positioned(
                  // top: 1.h,
                  // bottom: 1.h,
                  right: 0,
                  left: 0,
                  child: ChampAssetsWidget(
                    imagePath: ChampAssets.resultDialogBg,
                    width: Get.width,
                    height: Get.height,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChampAssetsWidget(
                          imagePath: ChampAssets.resultTitleImg,
                          imageScale: 2.8.w,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChampText(
                                      'Total Mark  :   ${con.questionList.length}',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      color: ColorUtils.appBlack,
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    ChampText(
                                      'Win Mark    :   ${con.winCount}',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      color: ColorUtils.appBlack,
                                    ),
                                    SizedBox(
                                      height: 5.sp,
                                    ),
                                    ChampText(
                                      'Lost Mark   :   ${con.lostCount}',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      color: ColorUtils.appBlack,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ChampText(
                                      '${ConstUtils.getPercentage(winCount: con.winCount, totalMark: con.questionList.length).toStringAsFixed(2)} %',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.center,
                                      color: ColorUtils.primary,
                                    ),
                                    ChampText(
                                        ConstUtils.getGrade(
                                            ConstUtils.getPercentage(
                                                winCount: con.winCount,
                                                totalMark:
                                                    con.questionList.length)),
                                        fontSize: 27.sp,
                                        fontWeight: FontWeight.w700,
                                        textAlign: TextAlign.center,
                                        color: ColorUtils.primary),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        ChampAssetsWidget(
                          imagePath: ConstUtils.getPercentage(
                                      winCount: con.winCount,
                                      totalMark: con.questionList.length) <
                                  35
                              ? ChampAssets.failImage
                              : ChampAssets.winnerImage,
                          imageScale: 5.5.sp,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
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
                                          image: AssetImage(
                                              ChampAssets.roundedSolid))),
                                  child: const Icon(
                                    Icons.refresh,
                                    color: ColorUtils.appWhite,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.back();
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
                                          image: AssetImage(
                                              ChampAssets.roundedSolid))),
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
