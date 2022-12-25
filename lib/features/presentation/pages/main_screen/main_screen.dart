import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/presentation/pages/chat/chat_page.dart';
import 'package:hmsi_app/features/presentation/pages/home/home_page.dart';
import 'package:hmsi_app/features/presentation/pages/news/news_page.dart';
import 'package:hmsi_app/features/presentation/pages/profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({super.key, required this.uid});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomePage(),
          NewsPage(),
          ChatPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        backgroundColor: Colors.white,
        inactiveColor: primaryColor,
        activeColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: primaryColor,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "News",
            icon: FaIcon(
              FontAwesomeIcons.newspaper,
              color: primaryColor,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Chat",
            icon: FaIcon(
              FontAwesomeIcons.message,
              color: primaryColor,
              size: 20,
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: FaIcon(
              FontAwesomeIcons.idBadge,
              color: primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
