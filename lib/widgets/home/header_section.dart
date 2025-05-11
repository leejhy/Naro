import 'package:flutter/material.dart';
import 'package:naro/styles/text_styles.dart';
import 'dart:math';

const List<String> noLetterMessages = [
  '오고 있는 편지가 없어요.\n지금 이 순간을 담아보는 건 어때요?',
  '아직 도착 예정인 편지가 없어요.\n오늘의 마음을 기록해 보는 건 어때요?',
  '아직 편지를 보내지 않았어요.\n미래의 내가 기다리고 있을지 몰라요.',
  '편지함이 고요해요.\n오늘의 감정을 남겨보는 건 어때요?',
  '지금의 내가, 미래의 나에게\n가장 큰 힘이 되어줄 수 있어요.',
  '언젠가 불안한 날의 내가\n오늘의 당신을 기억하게 될 거예요.',
  '언젠가 힘들어할 나에게\n따뜻한 한마디를 남겨보는 건 어때요?',
];

class HeaderSection extends StatefulWidget {
  const HeaderSection({
    super.key,
    required this.arrivalDate,
    required this.dDay,
    required this.letterCount,
  });

  final int letterCount;
  final DateTime arrivalDate;
  final int dDay;
  
  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late final String randomMessage;

  @override
  void initState() {
    super.initState();
    randomMessage = noLetterMessages[Random().nextInt(noLetterMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    final dDay = widget.dDay;
    final arrivalDate = widget.arrivalDate;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 124,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (dDay > 0) ... [
                Text('다가오는 편지', style: AppTextStyles.headingStyle),
                Text('D-$dDay', style: AppTextStyles.dDayStyle),
                SizedBox(height: 4),
                Text('${arrivalDate.year}년 '
                '${arrivalDate.month}월 '
                '${arrivalDate.day}일 도착 예정', style: AppTextStyles.dateStyle),
              ] else if (dDay == 0)... [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '오늘 도착한 편지한 편지가 있어요',
                      style: AppTextStyles.arrivalStyle,
                    ),
                  ),
                ),
              ] else ... [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      randomMessage,
                      style: AppTextStyles.headerSectionStyle,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}