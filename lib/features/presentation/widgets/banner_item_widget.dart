import 'package:flutter/material.dart';

class BannerItemWidget extends StatelessWidget {
  final String _images;
  // final List<String> _images;
  final int index;

  const BannerItemWidget({
    super.key,
    required String images,
    required this.index,
  }) : _images = images;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(_images),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
