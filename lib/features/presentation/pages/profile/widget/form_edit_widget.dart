import 'package:flutter/material.dart';

import '../../../../../const.dart';

class FormEditWidget extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const FormEditWidget({
    Key? key,
    this.title,
    this.controller,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.validator,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          maxLength: maxLength,
          style: TextStyle(color: AppColor.primaryColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppColor.primaryColor),
          ),
          validator: validator,
          // validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }
          //     return null;
          //   },
        ),
      ],
    );
  }
}
