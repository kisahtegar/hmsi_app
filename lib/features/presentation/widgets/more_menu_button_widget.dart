import 'package:flutter/material.dart';
import '../../../const.dart';

class MoreMenuButtonWidget extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;

  const MoreMenuButtonWidget({
    Key? key,
    this.borderRadius,
    this.onTap,
    required this.text,
    required this.icon,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
            AppSize.sizeHor(10),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
