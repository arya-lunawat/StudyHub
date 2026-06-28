import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/common/entities/course.dart';
import 'package:study_hub/common/values/constant.dart';
import 'package:study_hub/pages/home/bloc/home_page_blocs.dart';
import 'package:study_hub/pages/home/bloc/home_page_events.dart';

import '../../../common/values/colors.dart';
import '../../search/search_page.dart';
import '../bloc/home_page_states.dart';

AppBar buildAppBar(String avatar) {
  return AppBar(
    title: Container(
      margin: EdgeInsets.only(left: 7.w, right: 7.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 12.h,
            //child: Image.asset("assets/icons/menu.png"),
          ),
          GestureDetector(
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage("${AppConstants.SERVER_API_URL}$avatar"),
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget homePageText(String text, {Color color = AppColors.primaryText, int top = 20}) {
  return Container(
    margin: EdgeInsets.only(top: top.h),
    child: Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}

Widget searchView(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchPage()),
      );
    },
    child: Row(
      children: [
        Container(
          width: 280.w,
          height: 40.h,
          decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(15.h),
              border: Border.all(color: AppColors.primaryFourElementText)
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 17.w),
                width: 16.w,
                height: 16.w,
                child: Image.asset("assets/icons/search.png"),
              ),
              Container(
                width: 240.w,
                height: 40.h,
                child: TextField(
                  enabled: false, // Disable typing, just navigate
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(5,5,0,5),
                    hintText: "Search your course",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    hintStyle: TextStyle(color: AppColors.primarySecondaryElementText),
                  ),
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                  autocorrect: false,
                  obscureText: false,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13.w)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget slidersView(BuildContext context, HomePageStates state) {
  return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20.h),
            width: 325.w,
            height: 160.h,
            child: PageView(
              onPageChanged: (value){
                print(value.toString());
                context.read<HomePageBlocs>().add(HomePageDots(value));
              },
                children: [
                  _slidersContainer(path: "assets/icons/ImageA.png"),
                  _slidersContainer(path: "assets/icons/ImageB.png"),
                  _slidersContainer(path: "assets/icons/ImageC.png")
                ]
            )
        ),
        Container(
            child: DotsIndicator(
                dotsCount: 3,
                position: state.index.toDouble(),
                decorator: DotsDecorator(
                    color: AppColors.primaryThreeElementText,
                    activeColor: AppColors.primaryElement,
                    size: const Size.square(5.0),
                    activeSize: const Size(10.0, 5.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                )  // RoundedRectangleBorder
            )  // DotsIndicator
        ),

      ]
  );  // Column
}


Widget _slidersContainer({String path = "assets/icons/art.png"}) {
  return Container(
    width: 325.w,
    height: 160.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.h)),
        image:  DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(path)
        )  // DecorationImage
    ),  // BoxDecoration
  );  // Container
}

Widget menuView() {
  return Column(
    children: [
      Container(
        width: 325.w,
        margin: EdgeInsets.only(top: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _reusableText("Choose your course"),
            GestureDetector(
                child: _reusableText("", color: AppColors.primaryThreeElementText, fontSize: 14)
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 20.w),
        child: Row(
          children: [
            _reusableMenuText("Recent"),
            //_reusableMenuText("Popular", textColor: AppColors.primaryThreeElementText, backgroundColor: AppColors.primaryBackground),
            //_reusableMenuText("Newest", textColor: AppColors.primaryThreeElementText, backgroundColor: AppColors.primaryBackground),
          ],
        ),
      ),

    ],
  );
}


Widget _reusableText(String text, {Color color=AppColors.primaryText, int fontSize=16, FontWeight fontWeight=FontWeight.bold}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
    ),
  );
}

Widget _reusableMenuText(String menuText, {Color textColor=AppColors.primaryElementText, Color backgroundColor=AppColors.primaryElement}){
  return Container(
    margin: EdgeInsets.only(right: 20.w),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(7.w),
      border: Border.all(color: backgroundColor),
    ),
    padding: EdgeInsets.only(
      left: 15.w, right: 15.w, top: 5.h, bottom: 5.h,
    ),
    child: _reusableText(menuText,
        color: textColor,
        fontWeight: FontWeight.normal,
        fontSize: 12),
  );
}

Widget courseGrid(CourseItem item){
  return Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(AppConstants.SERVER_UPLOADS+item.thumbnail!),
          onError: (exception, stackTrace) {
            print('Failed to load image: $exception');
          },
        )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name??"",
          maxLines:1,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.left,
          softWrap: false,
          style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 5.h,),
        Text(
          item.description??"",
          maxLines:1,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.left,
          softWrap: false,
          style: TextStyle(
            color: AppColors.primaryFourElementText,
            fontSize: 8.sp,
            fontWeight: FontWeight.normal,
          ),
        )
      ],
    ),
  );
}