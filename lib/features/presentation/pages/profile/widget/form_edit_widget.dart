import 'package:flutter/material.dart';

import '../../../../../const.dart';

class FormEditWidget extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  const FormEditWidget({
    Key? key,
    this.title,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 16),
        ),
        TextFormField(
          controller: controller,
          style: TextStyle(color: AppColor.primaryColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppColor.primaryColor),
          ),
        ),
      ],
    );
  }
}
