import 'package:flutter/material.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/meediary_app.dart';
import 'package:meediary/services/object_box.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  late ObjectBox objectbox;
  late PostService postService;

  objectbox = await ObjectBox.create();
  final postBox = objectbox.store.box<Post>();
  postService = PostService(postBox, postBox.getAll().reversed.toList());

  runApp(
    MultiProvider(
      providers: [
        Provider<ObjectBox>(create: (_) => objectbox),
        ChangeNotifierProvider<PostService>(create: (_) => postService),
      ],
      child: const MeediaryApp(),
    ),
  );
}
