import 'package:flutter/material.dart';
import 'package:meediary/constants/enums.dart';
import 'package:meediary/constants/globals.dart';
import 'package:meediary/constants/routes.dart';
import 'package:meediary/pages/feed_page.dart';
import 'package:meediary/widgets/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomNavigationTab _currentTab = BottomNavigationTab.home;
  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      const FeedPage(),
      const Text('กำลังพัฒนา...'),
      const SizedBox(),
      const Text('กำลังพัฒนา...'),
      const Text('กำลังพัฒนา...'),
    ];
  }

  void _onTapNewPost(BuildContext context) async {
    await Navigator.of(context).pushNamed(RouteNames.addNewPostPage);

    if (mounted && _currentTab == BottomNavigationTab.newPost) {
      setState(() {
        _currentTab = BottomNavigationTab.home;
      });
    }
  }

  void _handleOnTabBottomNavigationBar(
      BottomNavigationTab tab, BuildContext context) {
    switch (tab) {
      case BottomNavigationTab.home:
        // TODO(taati): implement on tab home
        break;
      case BottomNavigationTab.search:
        // TODO(taati): implement on tab search
        break;
      case BottomNavigationTab.newPost:
        _onTapNewPost(context);
        break;
      case BottomNavigationTab.notification:
        // TODO(taati): implement on tab notification
        break;
      case BottomNavigationTab.profile:
        // TODO(taati): implement on tab profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        alignment: AlignmentDirectional.center,
        children: tabs,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (tab) async {
          if (tab == BottomNavigationTab.home && _currentTab == tab) {
            feedScrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
          _handleOnTabBottomNavigationBar(tab, context);
          setState(
            () {
              _currentTab = tab;
            },
          );
        },
      ),
    );
  }
}
