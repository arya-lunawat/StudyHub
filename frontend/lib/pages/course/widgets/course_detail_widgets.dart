import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/common/widgets/base_text_widget.dart';
import 'package:study_hub/pages/course/course_detail/bloc/course_detail_states.dart';

import '../../../common/values/colors.dart';
import '../../../common/values/constant.dart';
import '../../register/common_widgets.dart';

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: reusableText(
      "Course detail",
      color: Colors.black,
    ),
    elevation: 0,
  );
}

Widget thumbNail(String thumbnail) {
  return Container(
    width: 325.w,
    height: 200.h,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fitWidth,
        image: NetworkImage("${AppConstants.SERVER_UPLOADS}$thumbnail"),
      ),
    ),
  );
}

Widget menuView() {
  return Container(
    width: 325.w,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.circular(7.w),
                  border: Border.all(color: AppColors.primaryElement)
              ),  // BoxDecoration
              alignment: Alignment.center,
              child: reusableText("Course Page",
                  color: AppColors.primaryElementText,
                  fontWeight: FontWeight.normal,
                  fontSize: 10.sp
              )
          ),  // Container
        ),
        //_iconAndNum("assets/icons/people.png",0),
        //_iconAndNum("assets/icons/star.png",0)
      ],
    ),
  );
}
/*Widget _iconAndNum(String iconPath, int num) {
  return Container(

    margin: EdgeInsets.only(left: 30.w),
    child: Row(
      children: [
        Image(
          image: AssetImage(iconPath),
          width: 20.w,
          height: 20.h,
        ),  // Image
        reusableText(
            num.toString(),
            color: AppColors.primaryThreeElementText,
            fontSize: 11.sp,
            fontWeight: FontWeight.normal
        )
      ],
    ),  // Row
  );  // Container
}*/

Widget goBuyButton(String name) {
  return Container(
    padding: EdgeInsets.only(top: 13.h),
    width: 330.w,
    height: 50.h,
    decoration: BoxDecoration(
        color: AppColors.primaryElement,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: AppColors.primaryElement)
    ),  // BoxDecoration
    child: Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AppColors.primaryElementText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal
      ),  // TextStyle
    ),  // Text
  );  // Container
}

Widget descriptionText(String description){
  return reusableText(
      description,
      color: AppColors.primarySecondaryElementText,
      fontWeight: FontWeight.normal,
      fontSize: 11.sp
  );
}

Widget CourseLessonList() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            width: 325.w,
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icons/image_1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _listContainer(),
                    _listContainer(
                      fontSize: 10,
                      color: AppColors.primaryThreeElementText,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



Widget _listContainer({double fontSize = 13, Color color = AppColors.primaryText, fontWeight = FontWeight.bold}) {
  return Container(
    width: 200.w,
    margin: EdgeInsets.only(left: 6.w),
    child: Text(
      "Mobile App Development",
      overflow: TextOverflow.clip,
      maxLines: 1,
      style: TextStyle(
          color: color,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.bold
      ),  // TextStyle
    ),  // Text
  );  // Container
}
