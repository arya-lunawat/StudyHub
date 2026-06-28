import 'package:flutter/cupertino.dart';
import 'package:study_hub/common/entities/user.dart';
import 'package:study_hub/pages/global.dart';

class ProfileController {
  late BuildContext context;
  UserItem? get userProfile => Global.storageService.getUserProfile();

  static final ProfileController _singleton = ProfileController._internal();

  ProfileController._internal();

  factory ProfileController({required BuildContext context}) {
    _singleton.context = context;
    return _singleton;
  }

  Future<void> init() async {
    if (userProfile != null) {
      print("Loaded user profile: ${userProfile?.name}, ${userProfile?.email}");
    } else {
      print("No user profile found in storage");
    }
  }
}
