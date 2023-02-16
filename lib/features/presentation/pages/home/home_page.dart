import 'package:flutter/material.dart';

import '../../../../const.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../widgets/banner_item_widget.dart';
import '../../widgets/indicator_view_widget.dart';
import '../../widgets/profile_widget.dart';
import 'widget/icon_menu_widget.dart';

class HomePage extends StatefulWidget {
  final UserEntity currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  final List<String> _images = [
    "https://raw.githubusercontent.com/kisahtegar/Test-API/main/picture/naruto.png",
    "https://cdn.idntimes.com/content-images/duniaku/post/20200420/sasuke-smile-abcd327fe8d02f98c7e827c6f28d8f3d.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgeSbFYMVVf8YMcadKEB3HoOBD2_yNpZUQhg&usqp=CAU",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    debugPrint("HomePage[build]: Building!!");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 1,
        leading: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: profileWidget(imageUrl: widget.currentUser.profileUrl),
          ),
        ),
        title: Text(
          "Hi, ${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Menu
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  IconMenuWidget(
                    backgroundColor: Colors.orange.withOpacity(0.5),
                    image: "assets/images/pendaftaran.png",
                    imageSize: 45,
                    description: "Daftar",
                    onTapListener: () async {
                      openUrl("https://www.instagram.com/hmsi.ipem/");
                    },
                  ),
                  // IconMenuWidget(
                  //   backgroundColor: Colors.red.withOpacity(0.5),
                  //   image: "assets/images/chat.png",
                  //   imageSize: 50,
                  //   description: "Chat",
                  //   onTapListener: () {},
                  // ),
                  IconMenuWidget(
                    backgroundColor: Colors.blue.withOpacity(0.5),
                    image: "assets/images/absensi.png",
                    imageSize: 48,
                    description: "Event",
                    onTapListener: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.eventPage,
                        arguments: widget.currentUser,
                      );
                    },
                  ),
                  IconMenuWidget(
                    backgroundColor: Colors.blue.withOpacity(0.5),
                    image: "assets/images/about.png",
                    imageSize: 50,
                    description: "About",
                    onTapListener: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.aboutPage,
                      );
                    },
                  ),
                  Container(width: 80),
                  // Container(width: 80) // FakeContainer
                ],
              ),
            ),
            const Spacer(),

            // Information card view
            const Text(
              "Information",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSize.sizeVer(5),
            Column(
              children: [
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      var scale = _selectedIndex == index ? 1.0 : 0.9;
                      return TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 350),
                        tween: Tween(begin: scale, end: scale),
                        curve: Curves.ease,
                        child: BannerItemWidget(images: _images, index: index),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ),
                AppSize.sizeVer(6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      _images.length,
                      (index) => IndicatorViewWidget(
                        isView: _selectedIndex == index ? true : false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppSize.sizeVer(15),
          ],
        ),
      ),
    );
  }
}
