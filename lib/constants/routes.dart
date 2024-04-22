import 'package:flutter/material.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/pages/create_or_edit_post_page.dart';
import 'package:meediary/pages/custom_camera/take_picture_page.dart';
import 'package:meediary/pages/edit_profile_page.dart';
import 'package:meediary/pages/set_password_page.dart';
import 'package:meediary/pages/setting_page.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    RouteNames.createOrEditPostPage: (context) {
      final argument = ModalRoute.of(context)!.settings.arguments as Map?;

      Post? post;
      if (argument != null){
        post = argument[RouteParameters.post];
      }

      return CreateOrEditPostPage(
        post: post,
      );
    },
    RouteNames.editProfilePage: (context) {
      return const EditProfilePage();
    },
    RouteNames.settingPage: (context) {
      return const SettingPage();
    },
    RouteNames.setPasswordPage: (context) {
      return const SetPasswordPage();
    },
    RouteNames.takePicturePage: (context) {
      return const TakePicturePage();
    }
  };
}

class RouteNames {
  static const createOrEditPostPage = 'createOrEditPostPage';
  static const editProfilePage = 'editProfilePage';
  static const settingPage = 'settingPage';
  static const setPasswordPage = 'setPasswordPage';
  static const takePicturePage = 'takePicturePage';
}

class RouteParameters {
  static const post = 'post';
}
