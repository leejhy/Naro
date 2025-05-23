import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  // final String label;

  const ConfirmButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    // this.label = 'confirm'.tr(),
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
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? 
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2)
        )
      : Text('confirm'.tr(), style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(71, 114, 215, 1),
      )),
    );
  }
}
