 import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CancelButton({
    super.key,
    required this.onPressed,
    this.label = '취소',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFE0EDF4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: UIColors.textSubtle,
      )),
    );
  }
}
