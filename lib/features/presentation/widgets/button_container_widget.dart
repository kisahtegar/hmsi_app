import 'package:flutter/material.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? btnColor;
  final Color? textColor;
  final String? text;
  final VoidCallback? onTapListener;

  const ButtonContainerWidget({
    Key? key,
    this.btnColor,
    this.textColor,
    this.text,
    this.onTapListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            "$text",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
