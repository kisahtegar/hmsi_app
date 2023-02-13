import 'package:flutter/material.dart';

import '../../../const.dart';

class CustomTabBar extends StatelessWidget {
  final int index;

  const CustomTabBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomTabBarButton(
              text: "Event Info",
              textColor:
                  index == 0 ? AppColor.primaryColor : AppColor.secondaryColor,
              borderColor:
                  index == 0 ? AppColor.primaryColor : Colors.transparent,
            ),
          ),
          Expanded(
            child: CustomTabBarButton(
              text: "Interested",
              textColor:
                  index == 1 ? AppColor.primaryColor : AppColor.secondaryColor,
              borderColor:
                  index == 1 ? AppColor.primaryColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTabBarButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;

  const CustomTabBarButton({
    super.key,
    required this.text,
    required this.borderColor,
    required this.textColor,
    this.borderWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
