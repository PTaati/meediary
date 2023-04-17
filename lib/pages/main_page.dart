import 'package:flutter/material.dart';
import 'package:meediary/constants/app_theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meedairy',
      theme: AppTheme.applicationTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meediary'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Your diary for the age of social media.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
