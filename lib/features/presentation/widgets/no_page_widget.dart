import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../const.dart';

Widget noPageWidget({
  required String title,
  String? description = "",
  required IconData icon,
  double? titleSize,
  double? descriptionSize,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    FontAwesomeIcons.solidSun,
                    color: Colors.amber,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    FontAwesomeIcons.solidMoon,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSize.sizeVer(25),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSize.sizeVer(15),
        Text(
          description!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: descriptionSize,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );
}
