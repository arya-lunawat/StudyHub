import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:study_hub/common/values/constant.dart';
import 'package:study_hub/pages/global.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_blocs.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_events.dart';
import 'package:study_hub/pages/sign_in/bloc/sign_in_states.dart';

import '../../common/apis/user_api.dart';
import '../../common/entities/user.dart';
import '../home/home_controller.dart';

class SignInController {
  final BuildContext context;

  const SignInController({required this.context});

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        final state = context.read<SignInBloc>().state;
        String emailAddress = state.email.trim();
        String password = state.password.trim();

        if (emailAddress.isEmpty) {
          _showSnackBar("Please fill in your email address.");
          return;
        }
        if (password.isEmpty) {
          _showSnackBar("Please fill in your password.");
          return;
        }

        try {
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

          if (credential.user == null) {
            _showSnackBar("User does not exist.");
            return;
          }

          if (!credential.user!.emailVerified) {
            _showSnackBar("Email is not verified.");
            return;
          }

          var user = credential.user;
          if(user != null){
            String? displayName = user.displayName;
            String? email = user.email;
            String? id = user.uid;
            String? photoUrl = user.photoURL;

            LoginRequestEntity loginRequestEntity = LoginRequestEntity();
            loginRequestEntity.avatar = photoUrl;
            loginRequestEntity.name = displayName;
            loginRequestEntity.email = email;
            loginRequestEntity.open_id = id;
            loginRequestEntity.type = 1;

            debugPrint("User exists and is verified.");
            await asyncPostAllData(loginRequestEntity);

            _showSnackBar("Login successful!");
          } else {
            _showSnackBar("User does not exist.");
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            _showSnackBar("No user found for that email.");
          } else if (e.code == 'wrong-password') {
            _showSnackBar("Wrong password provided for that user.");
          } else if (e.code == 'invalid-email') {
            _showSnackBar("Invalid email format.");
          } else if (e.code == 'invalid-credential') {
            _showSnackBar("The supplied credentials are invalid.");
          } else {
            _showSnackBar("Login failed: ${e.message}");
          }
        }
      }
    } catch (e) {
      debugPrint("Sign-in error: ${e.toString()}");
      _showSnackBar("An unexpected error occurred. Try again.");
    }
  }

  Future<void> asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    try {
      EasyLoading.show(
          indicator: const CircularProgressIndicator(color: Colors.cyan),
          maskType: EasyLoadingMaskType.clear,
          dismissOnTap: true
      );

      var result = await UserAPI.login(params: loginRequestEntity);

      debugPrint("Login API Response: ${result.toString()}");
      debugPrint("Login Response Code: ${result.code}");
      debugPrint("Login Response Data: ${result.data}");

      if(result.code == 200 && result.data != null) {
        try {
          Global.storageService.setString(
              AppConstants.STORAGE_USER_PROFILE_KEY,
              jsonEncode(result.data!)
          );

          Global.storageService.setString(
              AppConstants.STORAGE_USER_TOKEN_KEY,
              result.data!.access_token ?? ''
          );

          EasyLoading.dismiss();

          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/application",
                    (route) => false
            );
          }
        } catch(e) {
          EasyLoading.dismiss();
          debugPrint("Saving local storage error: ${e.toString()}");
          _showSnackBar("Error saving user data: $e");
        }
      } else {
        EasyLoading.dismiss();
        _showSnackBar("Login failed: ${result.code}");
      }
    } catch(e) {
      EasyLoading.dismiss();
      debugPrint("API call error: ${e.toString()}");
      _showSnackBar("Network error. Try again later.");
    }
  }
}
