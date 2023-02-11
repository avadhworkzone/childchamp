import 'package:flutter/material.dart';
import 'package:childchamp/utils/extension_utils.dart';

class ChampAssetsWidget extends StatelessWidget {
  const ChampAssetsWidget(
      {Key? key,
      required this.imagePath,
      this.width,
      this.height,
      this.boxFit,
      this.imageScale})
      : super(key: key);
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final double? imageScale;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.fill,
      scale: imageScale ?? 1.sp,
    );
  }
}
