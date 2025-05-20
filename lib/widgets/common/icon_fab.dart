import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'package:flutter/services.dart';

class IconFab extends StatelessWidget {
  const IconFab({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 5),
      child: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: UIColors.black,
          onPressed: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          child: icon,
        ),
      ),
    );
  }
}