import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/common/routes/names.dart';
import 'package:study_hub/pages/application/application_page.dart';
import 'package:study_hub/pages/application/bloc/app_blocs.dart';
import 'package:study_hub/pages/course/course_detail/bloc/course_detail_blocs.dart';
import 'package:study_hub/pages/course/course_detail/course_detail.dart';
import 'package:study_hub/pages/global.dart';
import 'package:study_hub/pages/home/bloc/home_page_blocs.dart';
import 'package:study_hub/pages/home/home_page.dart';
import 'package:study_hub/pages/profile/settings/bloc/settings_blocs.dart';
import 'package:study_hub/pages/profile/settings/settings_page.dart';
import 'package:study_hub/pages/register/bloc/register_blocs.dart';
import 'package:study_hub/pages/register/register.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:study_hub/pages/sign_in/sign_in.dart';
import 'package:study_hub/pages/welcome/bloc/welcome_blocs.dart';
import 'package:study_hub/pages/welcome/welcome.dart';
import 'package:study_hub/pages/course/video_player/video_player_page.dart';

import '../../pages/course/bloc/course_blocs.dart';
import '../../pages/course/course_page.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppRoutes.INITIAL,
        page: const Welcome(),
        bloc: BlocProvider(create: (_) => WelcomeBloc()),
      ),
      // Sign In page
      PageEntity(
        route: AppRoutes.SIGN_IN,
        page: const SignIn(),
        bloc: BlocProvider(create: (_) => SignInBloc()),
      ),
      // Register page
      PageEntity(
        route: AppRoutes.REGISTER,
        page: const Register(),
        bloc: BlocProvider(create: (_) => RegisterBlocs()),
      ),
      PageEntity(
        route: AppRoutes.APPLICATION,
        page: BlocProvider(
          create: (_) => AppBlocs(),
          child: const ApplicationPage(),
        ),
      ),
      PageEntity(
        route: AppRoutes.HOME_PAGE,
        page: BlocProvider(
          create: (_) => HomePageBlocs(),
          child: HomePage(),
        ),
      ),
      PageEntity(
        route: AppRoutes.SETTINGS,
        page: BlocProvider(
          create: (_) => SettingsBlocs(),
          child: const SettingsPage(),
        ),
      ),
      //PageEntity(
        //route: AppRoutes.COURSE_DETAIL,
        //page: BlocProvider(
         // create: (_) => CourseBloc(),
          //child: const CourseDetailBloc(),
       // ),
      //),
      PageEntity(
        route: AppRoutes.COURSE_DETAIL,
        page: const CourseDetail(),
        bloc: BlocProvider(create: (_) => CourseDetailBloc()), // ✅ Correct bloc type
      ),
      PageEntity(
        route: AppRoutes.COURSE_VIDEO,
        page: const VideoPlayerPage(),
      ),
      PageEntity(
        route: AppRoutes.COURSES_PAGE,
        page: const CoursesPage(),
        bloc: BlocProvider(create: (_) => CourseBloc()),
      ),


    ];
  }

  static List<dynamic> allBlocProviders([BuildContext? context]) {
    List<dynamic> blocProviders = <dynamic>[];
    for (var bloc in routes()) {
      if (bloc.bloc != null) {
        blocProviders.add(bloc.bloc);
      }
    }
    return blocProviders;
  }

  // a modal that covers entire screen as we click on navigator object
  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      // check for route name matching when navigator gets triggered.
      var result = routes().where((element) => element.route == settings.name);
      if (result.isNotEmpty) {
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
        if (result.first.route == AppRoutes.INITIAL && deviceFirstOpen) {
          bool isLoggedin = Global.storageService.getIsLoggedIn();
          if (isLoggedin) {
            return MaterialPageRoute(
              builder: (_) => const ApplicationPage(),
              settings: settings,
            );
          }

          return MaterialPageRoute(
            builder: (_) => const SignIn(),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => result.first.page,
          settings: settings,
        );
      }
    }
    print("Invalid route name ${settings.name}");
    return MaterialPageRoute(
      builder: (_) => const SignIn(),
      settings: settings,
    );
  }
}

// Unify BlocProvider and routes/pages
class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({required this.route, required this.page, this.bloc});
}
