import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../const.dart';
import '../../cubits/user/get_single_user/get_single_user_cubit.dart';
import '../notification/notification_page.dart';
import '../home/home_page.dart';
import '../article/article_page.dart';
import '../profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({super.key, required this.uid});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
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
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            backgroundColor: AppColor.backGroundColor,
            body: ScrollConfiguration(
              behavior:
                  const MaterialScrollBehavior().copyWith(overscroll: false),
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  HomePage(currentUser: currentUser),
                  ArticlePage(currentUser: currentUser),
                  const NotificationPage(),
                  ProfilePage(currentUser: currentUser),
                ],
              ),
            ),
            bottomNavigationBar: CupertinoTabBar(
              onTap: navigationTapped,
              backgroundColor: Colors.white,
              inactiveColor: AppColor.primaryColor,
              activeColor: AppColor.primaryColor,
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: FaIcon(
                    FontAwesomeIcons.houseChimney,
                    color: _currentIndex == 0
                        ? AppColor.primaryColor
                        : AppColor.secondaryColor,
                    size: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Article",
                  icon: FaIcon(
                    FontAwesomeIcons.newspaper,
                    color: _currentIndex == 1
                        ? AppColor.primaryColor
                        : AppColor.secondaryColor,
                    size: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Notifications",
                  icon: FaIcon(
                    FontAwesomeIcons.bell,
                    color: _currentIndex == 2
                        ? AppColor.primaryColor
                        : AppColor.secondaryColor,
                    size: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: FaIcon(
                    FontAwesomeIcons.idBadge,
                    color: _currentIndex == 3
                        ? AppColor.primaryColor
                        : AppColor.secondaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        }
        // Loading Page
        return Scaffold(
          backgroundColor: AppColor.backGroundColor,
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
