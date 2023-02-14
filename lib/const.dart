import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// AppColor
class AppColor {
  static Color backGroundColor = Colors.white;
  static Color gradientFirst = const Color.fromARGB(255, 11, 17, 136);
  static Color gradientSecond = const Color(0xFF6985e8);
  static Color blueColor = const Color.fromRGBO(0, 149, 246, 1);
  static Color primaryColor = Colors.black;
  static Color secondaryColor = Colors.grey;
  static Color darkGreyColor = const Color.fromRGBO(97, 97, 97, 1);
  static Color kTitleTextColor = const Color(0xFF303030);
  static Color kTitleTextColorLight = Colors.white;
  static Color kTextLightColor = const Color.fromARGB(255, 61, 60, 60);
}

// AppTextStyle
class AppTextStyle {
  static TextStyle kTitleTextStyle = TextStyle(
    fontSize: 32,
    color: AppColor.kTitleTextColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle kTitleTextStyleLight = TextStyle(
    fontSize: 32,
    color: AppColor.kTitleTextColorLight,
    fontWeight: FontWeight.bold,
  );
  static TextStyle kSubTextStyle = TextStyle(
    fontSize: 14,
    color: AppColor.kTextLightColor,
  );
  static TextStyle kSubTextStyleLight = TextStyle(
    fontSize: 14,
    color: AppColor.kTitleTextColorLight,
  );
  static TextStyle kDescTextStyle = TextStyle(
    fontSize: 14,
    color: AppColor.secondaryColor,
  );
}

// AppSize
class AppSize {
  static Widget sizeVer(double height) {
    return SizedBox(height: height);
  }

  static Widget sizeHor(double width) {
    return SizedBox(width: width);
  }
}

// Page Route
class PageConst {
  static const String welcomePage = 'welcomePage';
  static const String signInPage = 'signInPage';
  static const String signUpPage = 'signUpPage';
  static const String editProfilePage = 'editProfilePage';
  static const String uploadArticlePage = 'uploadArticlePage';
  static const String detailArticlePage = 'detailArticlePage';
  static const String editArticlePage = 'editArticlePage';
  static const String eventPage = 'eventPage';
  static const String createEventPage = 'createEventPage';
}

// Firebase Collection
class FirebaseConst {
  static const String users = 'users';
  static const String articles = 'articles';
  static const String comment = 'comment';
  static const String reply = 'reply';
  static const String event = 'event';
}

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColor.blueColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// Open and Launching URL.
Future<void> openUrl(String url) async {
  final Uri urll = Uri.parse(url);
  if (!await launchUrl(urll, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

/// This widget used for loading indicator
loadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.black,
    ),
  );
}
