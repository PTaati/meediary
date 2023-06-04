import 'package:flutter/material.dart';
import 'package:meediary/pages/add_new_post_page.dart';
import 'package:meediary/pages/edit_profile_page.dart';
import 'package:meediary/pages/set_password_page.dart';
import 'package:meediary/pages/setting_page.dart';

class Routes{
 static Map<String, WidgetBuilder> routes = {
   RouteNames.addNewPostPage: (context) {
     return const AddNewPostPage();
   },
   RouteNames.editProfilePage: (context) {
     return const EditProfilePage();
   },
   RouteNames.settingPage: (context) {
     return const SettingPage();
   },
   RouteNames.setPasswordPage: (context) {
     return const SetPasswordPage();
   }
 };
}

class RouteNames {
  static const addNewPostPage = 'addNewPostPage';
  static const editProfilePage = 'editProfilePage';
  static const settingPage = 'settingPage';
  static const setPasswordPage = 'setPasswordPage';
}