import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';

class WritingTextField extends StatelessWidget {
  const WritingTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.fontSize,
    required this.fontWeight,
    required this.maxLength,
    required this.hintText,
    required this.hintTextWeight,
    this.expands = false,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLength;
  final String hintText;
  final FontWeight hintTextWeight;
  final bool expands;
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      maxLength: maxLength,
      expands: expands,
      maxLines: expands ? null : 1,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: hintTextWeight,
          color: UIColors.hintText
        ),
        border: InputBorder.none,
      ),
    );
  }
}