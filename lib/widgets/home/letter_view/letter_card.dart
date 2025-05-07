import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/widgets/home/letter_view/letter_icon_box.dart';
import 'package:naro/widgets/home/letter_view/letter_info_box.dart';
import 'package:naro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/services/firebase_provider.dart';
import 'package:naro/services/database_helper.dart';

class LetterCard extends ConsumerStatefulWidget {
  const LetterCard({
    super.key,
    required this.letter,
  });
  final Map<String, dynamic> letter;

  @override
  ConsumerState<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends ConsumerState<LetterCard> {

  void onTapLetter(bool isOpened) {
    if (!isOpened) {
      showAutoDismissDialog(context, "편지가 도착하려면\n조금 더 시간이 필요해요");
      return;
    }
    context.push('/letter/${widget.letter['id']}');
  }

  @override
  Widget build(BuildContext context) {
    final dDay = calculateDday(DateTime.parse(widget.letter['arrival_at']));
    final analytics = ref.read(firebaseAnalyticsProvider);
    final bool isOpened = dDay <= 0;
    const double cardWidth = 0.72;

    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      shadowColor: const Color.fromARGB(82, 0, 0, 0),
      elevation: 2,
      child: InkWell(
        splashColor: const Color(0xFFBFE6F5),
        highlightColor: const Color.fromARGB(30, 0, 0, 0),
        borderRadius: BorderRadius.circular(8),
        onTap: () async{
          final username = await DatabaseHelper.getUserName();
          debugPrint('username: $username');
          await analytics.logEvent(
            name: 'letter_card_open',
            parameters: {
              'username': username,
              'letter_id': widget.letter['id'],
            },
          );
          onTapLetter(isOpened);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LetterIconBox(
                flex: 55,
                isOpened: isOpened,
                widthFactor: cardWidth,
              ),
              LetterInfoBox(
                flex: 60,
                title: widget.letter['title'],
                arrivalAt: widget.letter['arrival_at'],
                dDay: dDay,
                widthFactor: cardWidth,
              ),
            ],
          )
        ),
      ),
    );
  }
}