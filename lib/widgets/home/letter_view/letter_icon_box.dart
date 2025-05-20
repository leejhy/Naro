import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';

class LetterIconBox extends StatelessWidget {
  const LetterIconBox({
    super.key,
    required this.isOpened,
    required this.widthFactor,
    required this.flex,
  });

  final bool isOpened;
  final int flex;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          decoration: BoxDecoration(
            color: UIColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color.fromRGBO(0, 0, 0, 0.05),
            //     blurRadius: 1,
            //     offset: const Offset(0,2),
            //   ),
            // ],
          ),
          child: Icon(
            isOpened ? Icons.drafts_rounded : Icons.mail_rounded,
            size: 34,
            color: UIColors.black,
          ),
        ),
      ),
    );
  }
}