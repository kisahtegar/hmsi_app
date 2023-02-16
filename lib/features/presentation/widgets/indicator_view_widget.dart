import 'package:flutter/material.dart';

class IndicatorViewWidget extends StatelessWidget {
  final bool isView;

  const IndicatorViewWidget({
    super.key,
    required this.isView,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: isView ? 22.0 : 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          color: isView ? Colors.orange : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
