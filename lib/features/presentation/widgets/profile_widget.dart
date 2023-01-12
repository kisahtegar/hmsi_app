import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/images/profile_default.png',
        fit: BoxFit.cover,
        height: 10,
        width: 10,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return const CircularProgressIndicator();
        },
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/profile_default.png',
          fit: BoxFit.cover,
          height: 10,
          width: 10,
        ),
      );
    }
  } else {
    return Image.file(image, fit: BoxFit.cover);
  }
}
