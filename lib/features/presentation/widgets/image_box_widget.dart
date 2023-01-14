import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget imageBoxWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Container(
        color: Colors.grey,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return const CircularProgressIndicator();
        },
        errorWidget: (context, url, error) => Container(
          color: Colors.grey,
        ),
      );
    }
  } else {
    return Image.file(image, fit: BoxFit.cover);
  }
}
