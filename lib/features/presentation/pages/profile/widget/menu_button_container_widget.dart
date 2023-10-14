import 'package:flutter/material.dart';

class MenuButtonContainerWidget extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final String text;

  const MenuButtonContainerWidget({
    Key? key,
    this.borderRadius,
    this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Ink(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
