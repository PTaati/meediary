import 'package:flutter/material.dart';
import 'package:meediary/pages/add_new_post_page.dart';
import 'package:meediary/pages/edit_profile_page.dart';

class Routes{
 static Map<String, WidgetBuilder> routes = {
   RouteNames.addNewPostPage: (context) {
     return const AddNewPostPage();
   },
   RouteNames.editProfilePage: (context) {
     return const EditProfilePage();
   },
 };
}

class RouteNames {
  static const addNewPostPage = 'addNewPostPage';
  static const editProfilePage = 'editProfilePage';
}