import 'package:flutter/material.dart';

// Color
const backGroundColor = Colors.white;
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.black;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1);
const kTitleTextColor = Color(0xFF303030);
const kTextLightColor = Color.fromARGB(255, 61, 60, 60);

// Text Style
const kTitleTextStyle = TextStyle(
    fontSize: 32, color: kTitleTextColor, fontWeight: FontWeight.bold);
const kSubTextStyle = TextStyle(fontSize: 14, color: kTextLightColor);

// SizedBox space
Widget sizeVer(double height) {
  return SizedBox(height: height);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}
