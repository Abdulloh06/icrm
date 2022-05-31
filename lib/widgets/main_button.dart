/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onTap,
    this.borderRadius = 10,
    this.fontSize = 14,
    this.padding = const EdgeInsets.all(15),
  }) : super(key: key);

  final Color color;
  final String title;
  final VoidCallback onTap;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )),
        padding: MaterialStateProperty.all(padding),
      ),
      onPressed: onTap,
      child: Center(
        child: LocaleText(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
