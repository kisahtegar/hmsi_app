import 'package:flutter/material.dart';

import '../../../../../const.dart';

class IconMenuWidget extends StatelessWidget {
  final Color backgroundColor;
  final String image;
  final double imageSize;
  final String description;
  final VoidCallback? onTapListener;

  const IconMenuWidget({
    Key? key,
    required this.backgroundColor,
    required this.image,
    required this.imageSize,
    required this.description,
    this.onTapListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      child: InkWell(
        onTap: onTapListener,
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              SizedBox(
                width: 50,
                height: 55,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 43,
                        width: 43,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        image,
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                  ],
                ),
              ),
              AppSize.sizeVer(6),
              Text(
                description,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
