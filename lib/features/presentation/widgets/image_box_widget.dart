import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget imageBoxWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text(
            "No image selected",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
            child: CircularProgressIndicator(),
          );
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
