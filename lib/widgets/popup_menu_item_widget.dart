import 'package:flutter/material.dart';

class PopupMenuItemWidget extends StatelessWidget {
  final Color? color;
  final String? title;
  const PopupMenuItemWidget({
    super.key,
    this.color,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Center(
        child: Text(
          title ?? '',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
