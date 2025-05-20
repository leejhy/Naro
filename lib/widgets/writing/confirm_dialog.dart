import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/widgets/common/cancel_button.dart';
import 'package:naro/widgets/common/confirm_button.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    super.key,
    required this.insertLetter,
    required this.ads,
  });

  final Future<int> Function() insertLetter;
  final RewardedAd? ads;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isSubmitting = false;

  void _handleSubmit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    final id = await widget.insertLetter();

    if (widget.ads == null) {
      if (mounted) {
        Navigator.pop(context);
        context.go('/result/$id');
      }
      return ;
    }
    widget.ads!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (mounted) {
          Navigator.pop(context);
          context.go('/result/$id');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(240, 250, 255, 1),
      title: const Text('저장하시겠습니까?'),
      content: const Text('광고가 끝난 후 편지가 저장됩니다.', 
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Color(0xFF444444),
        ),
      ),
      actions: [
        CancelButton(onPressed: () => Navigator.pop(context)),
        ConfirmButton(
          onPressed: _handleSubmit,
          isLoading: _isSubmitting
        ),
      ],
    );
  }
}
