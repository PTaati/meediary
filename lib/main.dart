import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meediary/data_models/chat_message.dart';
import 'package:meediary/data_models/post.dart';
import 'package:meediary/data_models/user.dart';
import 'package:meediary/meediary_app.dart';
import 'package:meediary/services/chat_service.dart';
import 'package:meediary/services/notification_service.dart';
import 'package:meediary/services/object_box.dart';
import 'package:meediary/services/post_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  final notificationService = NotificationService();

  await notificationService.setUpNotification();

  final cameras = await availableCameras();

  late ObjectBox objectbox;
  late PostService postService;
  late ChatService chatService;

  objectbox = await ObjectBox.create();
  final postBox = objectbox.store.box<Post>();
  final userBox = objectbox.store.box<User>();
  final chatMessageBox = objectbox.store.box<ChatMessage>();

  late User user;
  final users = userBox.getAll();
  if (users.isEmpty) {
    user = User();
    userBox.put(user);
  } else {
    user = users.first;
  }

  postService = PostService(postBox, postBox.getAll().reversed.toList());

  final chatMessageList = chatMessageBox.getAll();

  chatMessageList.sort((a, b) {
    return a.timeToSend.compareTo(b.timeToSend);
  });

  chatService = ChatService(chatMessageBox, chatMessageList);

  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        Provider<ObjectBox>(create: (_) => objectbox),
        ChangeNotifierProvider<PostService>(create: (_) => postService),
        ChangeNotifierProvider<ChatService>(create: (_) => chatService),
        ChangeNotifierProvider<User>(create: (_) => user),
        Provider<NotificationService>(create: (_) => notificationService),
        Provider<List<CameraDescription>>(create: (_) => cameras),
      ],
      child: const MeediaryApp(),
    ),
  );
}
