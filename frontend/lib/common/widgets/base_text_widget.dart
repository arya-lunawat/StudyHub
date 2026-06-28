import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/values/colors.dart';
import 'package:flutter/cupertino.dart';

Widget _reusableText(String text, {Color color=AppColors.primaryText, double fontSize=16, FontWeight fontWeight=FontWeight.bold}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
    ),
  );
}