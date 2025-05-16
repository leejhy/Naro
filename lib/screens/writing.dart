import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naro/controllers/writing_logic.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/common/icon_fab.dart';
import 'package:naro/widgets/writing/body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:naro/utils/ad_manager.dart';
import 'package:naro/utils/utils.dart';
import 'package:naro/widgets/writing/app_bar.dart';

class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  late WritingLogic logic;
  @override
  void initState() {
    super.initState();
    logic = WritingLogic(ref);
  }
  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!logic.dialogShown) {
      final route = ModalRoute.of(context);
      final animation = route is PageRoute ? route.animation : null;
      if (animation != null) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed && !logic.dialogShown) {
            logic.dialogShown = true;
            logic.showDateDialog(context, initial: true);
          }
        });
      } else {
        logic.dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          logic.showDateDialog(context, initial: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.backgroundGray,
      appBar: WritingAppBar(
        arrivalDate: logic.arrivalDateController.text,
        onTapCalendar: () {
          HapticFeedback.lightImpact();
          logic.analytics.logEvent(name: 'select_date_writing');
          logic.showDateDialog(context);
        },
      ),
      body: WritingBody(
        titleController: logic.titleController,
        contentController: logic.contentController,
        imageController: logic.imageController,
      ),
      floatingActionButton: IconFab(
        icon: const Icon(Icons.check, color: UIColors.white, size: 30),
        onPressed: () {
          if (logic.titleController.text.isEmpty || logic.contentController.text.isEmpty) {
            showAutoDismissDialog(context, '제목과 내용을 입력해주세요');
            return;
          }
          FocusScope.of(context).requestFocus(logic.blankFocus);
          showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
              insertLetter: logic.insertLetter,
              ads: AdManager.instance.rewardedAd,
            ),
          );
        },
      ),
    );
  }
}

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
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
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
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('취소', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          )),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _handleSubmit,
          child: _isSubmitting ? 
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('저장', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 17, 12, 12),
          )),
        ),
      ],
    );
  }
}
