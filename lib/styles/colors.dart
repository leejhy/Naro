import 'package:flutter/material.dart';

class UIColors {
  static const Color white = Color.fromRGBO(255, 254, 254, 1);
  static const Color white90 = Color.fromRGBO(255, 254, 254, 0.9);
  static const Color black = Color.fromRGBO(23, 23, 27, 1);
  static const Color backgroundGray = Color(0xffF9FAFB);
  static const Color textSubtle = Color(0xff6B7280);
  static const Color hintText = Color(0xFF797979);

  static final backgroundGradient = LinearGradient(
                            colors: [Color(0xFFE3F7FF), 
                            Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment(0, 0.5),
                          );
  static const Color appbarShadow = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color cardShadow = Color.fromRGBO(0, 0, 0, 0.35);
  static const Color cardBackground = Color(0xFFEBF6FB);
  
}