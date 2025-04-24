import 'package:flutter/material.dart';

class LetterIconBox extends StatelessWidget {
  const LetterIconBox({
    super.key,
    required this.isOpened,
    required this.widthFactor,
    required this.flex,
  });

  /// true ➜ envelope is open (도착 완료), false ➜ closed (아직 도착 전)
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
            color: const Color(0xffF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isOpened ? Icons.drafts_rounded : Icons.mail_rounded,
            size: 34,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}