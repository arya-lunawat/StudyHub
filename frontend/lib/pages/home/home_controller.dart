import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/common/entities/entities.dart';
import '../../common/apis/course_api.dart';
import '../../common/entities/user.dart';
import '../global.dart';
import 'bloc/home_page_blocs.dart';
import 'bloc/home_page_events.dart';
import 'package:study_hub/pages/global.dart';

class HomeController {
  late BuildContext context;
  UserItem? get userProfile => Global.storageService.getUserProfile();

  static final HomeController _singleton = HomeController._external();

  HomeController._external();
  //this is a factory constructor
  //makes sure you have the the original only one instance
  factory HomeController({required BuildContext context}) {
    _singleton.context = context;
    return _singleton;
  }


Future<void> init() async {

    if(Global.storageService.getUserToken().isNotEmpty){
      var result = await CourseAPI.courseList();
      print("the result is ${result.data?[0]}");
      if(result.code==200){
        if(context.mounted){
          context.read<HomePageBlocs>().add(HomePageCourseItem(result.data!));
        }
      }else{
        print(result.code);
      }
    }else{
      print("User has already logged out");
    }
  }
}




