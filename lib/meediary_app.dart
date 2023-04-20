import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meediary/constants/app_theme.dart';
import 'package:meediary/constants/routes.dart';
import 'package:meediary/pages/main_page.dart';

class MeediaryApp extends StatefulWidget {
  const MeediaryApp({Key? key}) : super(key: key);

  @override
  State<MeediaryApp> createState() => _MeediaryAppState();
}

class _MeediaryAppState extends State<MeediaryApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      theme: AppTheme.applicationTheme(),
      routes: Routes.routes,
      home: const MainPage(),
    );
  }
}
