import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/data_models/user.dart';
import 'package:meediary/meediary_app.dart';
import 'package:meediary/services/object_box.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  late ObjectBox objectbox;
  late PostService postService;

  objectbox = await ObjectBox.create();
  final postBox = objectbox.store.box<Post>();
  final userBox = objectbox.store.box<User>();

  late User user;
  final users = userBox.getAll();
  if (users.isEmpty){
    user = User();
    userBox.put(user);
  } else {
    user = users.first;
  }

  postService = PostService(postBox, postBox.getAll().reversed.toList());

  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        Provider<ObjectBox>(create: (_) => objectbox),
        ChangeNotifierProvider<PostService>(create: (_) => postService),
        ChangeNotifierProvider<User>(create: (_) => user),
      ],
      child: const MeediaryApp(),
    ),
  );
}
