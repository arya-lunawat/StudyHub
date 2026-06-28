import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/common/values/colors.dart';

// ---------------- AppBar ----------------
AppBar buildAppBar(String type) {
  return AppBar(
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppColors.primarySecondaryBackground,
        height: 1.0,
      ),
    ),
    title: Text(
      type,
      style: TextStyle(
        color: AppColors.primaryText,
        fontSize: 20.sp,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

// ---------------- Third Party Login Icons ----------------
Widget buildThirdPartyLogin(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
    padding: EdgeInsets.only(left: 50.w, right: 50.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //_reusableIcons("google"),
        //_reusableIcons("apple"),
        //_reusableIcons("facebook"),
      ],
    ),
  );
}

Widget _reusableIcons(String iconName) {
  return GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 40.w,
      height: 40.w,
      child: Image.asset("assets/icons/$iconName.png"),
    ),
  );
}

// ---------------- Reusable Text Widget ----------------
Widget reusableText(
    String text, {
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
    }) {
  return Padding(
    padding: EdgeInsets.only(left: 25.w, bottom: 5.h),
    child: Text(
      text,
      style: TextStyle(
        color: color ?? Colors.grey.withOpacity(0.6),
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 16.sp,
      ),
    ),
  );
}

// ---------------- Main Login Page Layout ----------------
Widget buildLoginPage(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: buildAppBar("Log In"),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildThirdPartyLogin(context),
          reusableText("Or use your email account to login"),
          Container(
            margin: EdgeInsets.only(top: 66.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reusableText(
                  "Email",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildTextField(String hintText, String textType, String iconName,
    void Function(String value)? func
    ) {
  return Container(
    width: 325.w,
    height: 50.h,
    margin: EdgeInsets.only(bottom: 20.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
      border: Border.all(color: AppColors.primaryFourElementText),
    ),
    child: Row(
      children: [
        Container(
          width: 16.w,
          margin: EdgeInsets.only(left: 17.w),
          height: 16.w,
          child: Image.asset("assets/icons/$iconName.png"),
        ),
        SizedBox(
          width: 270.w,
          height: 50.h,
          child: TextField(
            onChanged: (value)=>func!(value),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hintStyle: const TextStyle(
                    color: AppColors.primarySecondaryElementText
                )
            ),

            style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.normal,
                fontSize: 16.sp
            ),
            autocorrect: false,
            obscureText: textType=="password"?true:false,
          ),
        ),
      ],
    ),
  );
}

Widget forgotPassword() {
  return Container(
    margin: EdgeInsets.only(left: 25.w, top: 20.h),
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: () {

      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(
            color: AppColors.primaryText,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryText,
            decorationThickness: 1.5,
            fontSize: 14.sp
        ), // TextStyle
      ), // Text
    ), // GestureDetector
  ); // Container
}

Widget buildLoginAndRegButton(String buttonName, String buttonType, void Function()? func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: buttonType=="login"?30.h:15.h),
      decoration: BoxDecoration(
          color: buttonType=="login"?AppColors.primaryElement:AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(15.w),
          border: Border.all(
            color: buttonType=="login"?Colors.transparent:AppColors.primaryFourElementText,
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 2,
              color: Colors.grey.withOpacity(0.1),
              offset: const Offset(0, 1),
            )
          ]
      ), // BoxDecoration
      child: Center(child: Text(
        buttonName,
        style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            color: buttonType=="login"?AppColors.primaryBackground:AppColors.primaryText
        ),
      )),
    ), // Container
  ); // GestureDetector
}