import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/pages/application/bloc/app_blocs.dart';
import 'package:study_hub/pages/home/bloc/home_page_blocs.dart';
import 'package:study_hub/pages/register/bloc/register_blocs.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:study_hub/pages/welcome/bloc/welcome_blocs.dart';



class AppBlocProviders {
  static get allBlocProviders => [
    BlocProvider(lazy: false, create: (context) => WelcomeBloc()),
    BlocProvider(lazy: false, create: (context) => AppBlocs()),
    BlocProvider(create: (context) => SignInBloc()),
    BlocProvider(create: (context) => RegisterBlocs()),
    BlocProvider(create: (context) => HomePageBlocs()),
  ];
}
