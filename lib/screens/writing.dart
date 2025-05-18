import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naro/controllers/writing_logic.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/common/icon_fab.dart';
import 'package:naro/widgets/writing/body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/utils/ad_manager.dart';
import 'package:naro/utils/utils.dart';
import 'package:naro/widgets/writing/app_bar.dart';
import 'package:naro/widgets/writing/confirm_dialog.dart';

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
