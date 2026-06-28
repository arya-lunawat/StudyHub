import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/common/routes/names.dart';
import 'package:study_hub/common/values/constant.dart';
import 'package:study_hub/pages/global.dart';
import 'package:study_hub/pages/profile/settings/bloc/settings_blocs.dart';
import 'package:study_hub/pages/profile/settings/bloc/settings_states.dart';
import 'package:study_hub/pages/profile/settings/widgets/settings_widgets.dart';

import '../../application/bloc/app_blocs.dart';
import '../../application/bloc/app_events.dart';
import '../../home/bloc/home_page_blocs.dart';
import '../../home/bloc/home_page_events.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void removeUserData(){
    context.read<AppBlocs>().add(const TriggerAppEvent(0));
    context.read<HomePageBlocs>().add(const HomePageDots(0));
    Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
    Global.storageService.remove(AppConstants.STORAGE_USER_PROFILE_KEY);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.SIGN_IN, (route)=>false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:   buildAppbar(),
        body: SingleChildScrollView(
            child: BlocBuilder<SettingsBlocs, SettingsStates>(
                builder: (context,state){
                  return Container(
                      child: Column(
                          children: [
                            settingsButton(context, removeUserData)
                          ],
                      ),
                  );
                }
            )
        )
    );

  }
}
