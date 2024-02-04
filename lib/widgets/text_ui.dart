import 'package:flutter/material.dart';

class TextUI extends StatelessWidget {
  const TextUI(
      {super.key,
      required this.text,
      this.fontSize = 12,
      this.textColor = const Color.fromARGB(255, 255, 255, 255),
      this.isShadow = true});

  final String text;
  final double fontSize;
  final Color textColor;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          shadows: isShadow
              ? const [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-0.8, -0.8),
                      color: Colors.black),
                  Shadow(
                      // bottomRight
                      offset: Offset(0.8, -0.8),
                      color: Colors.black),
                  Shadow(
                      // topRight
                      offset: Offset(0.8, 2.0),
                      color: Colors.black),
                  Shadow(
                      // topLeft
                      offset: Offset(-0.8, 2.0),
                      color: Colors.black),
                ]
              : []),
    );
  }
}
