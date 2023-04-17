import 'package:flutter/material.dart';
import 'package:meediary/pages/main_page.dart';
import 'package:meediary/services/object_box.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  late ObjectBox objectbox;

  objectbox = await ObjectBox.create();

  runApp(
    MultiProvider(
      providers: [
        Provider<ObjectBox>(create: (_) => objectbox),
      ],
      child: const MainPage(),
    ),
  );
}
