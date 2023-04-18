import 'package:flutter/material.dart';
import 'package:meediary/constants/enums.dart';
import 'package:meediary/constants/sizes.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Future<void> Function(BottomNavigationTab) onTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white54,
              blurRadius: Sizes.boxShadowBlurRadius,
            ),
          ],
        ),
        child: BottomNavigationBar(
          iconSize: Sizes.iconSize,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined),
              activeIcon: Icon(Icons.add_circle),
              label: 'New Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentTab,
          onTap: (index) async {
            setState(() {
              _currentTab = index;
            });
            await widget.onTap(BottomNavigationTab.values[_currentTab]);
            if (mounted && _currentTab == BottomNavigationTab.newPost.index){
              setState(() {
                _currentTab = BottomNavigationTab.home.index;
              });
            }
          },
        ),
      ),
    );
  }
}
