import 'package:flutter/material.dart';
import 'package:meediary/pages/add_new_post_page.dart';

class Routes{
 static Map<String, WidgetBuilder> routes = {
   RouteNames.addNewPostPage: (context) {
     return const AddNewPostPage();
   }
 };
}

class RouteNames {
  static const addNewPostPage = 'addNewPostPage';
}