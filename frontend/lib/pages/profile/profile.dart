import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/pages/profile/widgets/profile_widgets.dart';
import 'package:study_hub/pages/global.dart';
import 'package:study_hub/common/entities/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Global.storageService.getUserProfile();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profileIconAndEditButton(),
                SizedBox(height: 30.h),
                userProfile != null
                    ? userInfoSection(userProfile)
                    : SizedBox(),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: buildListView(context),
                ),
              ]
          ),
        ),
      ),
    );
  }
}