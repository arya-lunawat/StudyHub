import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/pages/register/bloc/register_blocs.dart';

import '../../common/values/constant.dart';

class RegisterController {
  final BuildContext context;
  const RegisterController({required this.context});

  // SnackBar helper
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
    debugPrint("SnackBar: $message"); // Also print to console
  }

  Future<void> handleEmailRegister() async {
    final state = context.read<RegisterBlocs>().state;
    String userName = state.userName.trim();
    String email = state.email.trim();
    String password = state.password.trim();
    String rePassword = state.rePassword.trim();

    debugPrint("RegisterController: Starting registration for $email");

    // Validation
    if (userName.isEmpty) {
      _showSnackBar("User name cannot be empty.");
      debugPrint("Registration failed: user name empty");
      return;
    }
    if (email.isEmpty) {
      _showSnackBar("Email cannot be empty.");
      debugPrint("Registration failed: email empty");
      return;
    }
    if (password.isEmpty) {
      _showSnackBar("Password cannot be empty.");
      debugPrint("Registration failed: password empty");
      return;
    }
    if (rePassword.isEmpty || rePassword != password) {
      _showSnackBar("Password confirmation does not match.");
      debugPrint("Registration failed: password confirmation mismatch");
      return;
    }

    try {
      debugPrint("RegisterController: Creating Firebase user");
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        debugPrint("Firebase user created: ${credential.user?.uid}");

        try {
          await credential.user?.sendEmailVerification();
          await credential.user?.updateDisplayName(userName);
          String photoUrl = "uploads/default.png";
          await credential.user?.updatePhotoURL(photoUrl);
          debugPrint("Verification email sent to $email");

        } catch (e) {
          debugPrint("Failed to send verification email: ${e.toString()}");
          _showSnackBar("Failed to send verification email. Check your connection or try later.");
          return;
        }

        await credential.user?.updateDisplayName(userName);
        debugPrint("Display name updated to $userName");

        _showSnackBar(
          "A verification email has been sent. Please check your inbox and verify your account to continue.",
        );

        Navigator.of(context).pop(); // Return to login or previous screen
      } else {
        debugPrint("Firebase user creation returned null user");
        _showSnackBar("Registration failed. Please try again.");
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
      if (e.code == 'weak-password') {
        _showSnackBar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showSnackBar("The email is already in use.");
      } else if (e.code == 'invalid-email') {
        _showSnackBar("The email address is invalid.");
      } else {
        _showSnackBar("Registration failed. Please try again.");
      }
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}");
      _showSnackBar("An unexpected error occurred. Please try again.");
    }
  }
}
