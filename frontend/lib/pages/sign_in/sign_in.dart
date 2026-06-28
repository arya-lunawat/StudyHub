import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_states.dart';
import 'package:study_hub/pages/sign_in/sign_in_controller.dart';
//import 'package:study_hub/pages/sign_in/widgets/sign_in_widgets.dart';
import '../register/common_widgets.dart';
import 'bloc/sign_in_events.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: buildAppBar("Log In"),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildThirdPartyLogin(context),
                      Center(child: reusableText(
                          "Or use your email account to login")),
                      Container(
                        margin: EdgeInsets.only(top: 40.h),
                        padding: EdgeInsets.only(left: 25.w, right: 25.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            reusableText("Email"),
                            SizedBox(height: 2.h,),
                            buildTextField(
                                "Enter your email address", "email", "user",
                              (value){
                                  context.read<SignInBloc>().add(EmailEvent(value));
                            }
                            ),
                            reusableText("Password"),
                            SizedBox(height: 2.h,),
                            buildTextField(
                                "Enter your password", "password", "lock",
                                    (value) {
                                  context.read<SignInBloc>().add(
                                      PasswordEvent(value));
                                })

                          ],
                        ),
                      ),
                      forgotPassword(),
                      buildLoginAndRegButton("Log in", "login", (){
                              SignInController(context: context).handleSignIn("email");
                          }
                      ),
                      buildLoginAndRegButton("Sign Up", "register",(){
                          Navigator.of(context).pushNamed("/register");
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}