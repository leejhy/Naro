import 'package:flutter/material.dart';
import 'dart:ui';

int calculateDday(DateTime arrivalAt) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  Duration difference = arrivalAt.difference(today);
  int dDay = difference.inDays;//하루추가

  return dDay;
}

Future<void> showAutoDismissDialog(BuildContext context, String message, {int durationMs = 1250}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      Future.delayed(Duration(milliseconds: durationMs), () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });

      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 250, 255, 0.95),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 40,
                  color: Color(0xFF4A90E2)
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                    fontFamily: 'Inter',
                    decoration: TextDecoration.none,//
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: child,
        ),
      );
    },
  );
}