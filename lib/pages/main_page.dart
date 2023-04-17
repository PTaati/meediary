import 'package:flutter/material.dart';
import 'package:meediary/constants/app_theme.dart';
import 'package:meediary/constants/enums.dart';
import 'package:meediary/widgets/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomNavigationTab _currentTab = BottomNavigationTab.home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.applicationTheme(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_currentTab.name),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          onTap: (tab) {
            setState(
              () {
                _currentTab = tab;
              },
            );
          },
        ),
      ),
    );
  }
}
