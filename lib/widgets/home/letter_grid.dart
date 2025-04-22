import 'package:flutter/material.dart';
import 'package:naro/widgets/home/letter_card.dart';


class LetterGrid extends StatefulWidget {
  final List<Map<String, dynamic>> letters;

  const LetterGrid({
    super.key,
    required this.letters,
  });

  @override
  State<LetterGrid> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterGrid> {

  //todo dday 계산
  String? calculateDday(DateTime arrivalAt) {
    DateTime now = DateTime.now();
    Duration difference = arrivalAt.difference(now);
    int dDay = difference.inDays;
  
    if (dDay < 0) return null;
    if (dDay == 0) return 'Day';
    return dDay.toString();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    );

    final dDayStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    );

    final dateStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.1,
      color: Color(0xff6B7280),
    );
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final letter = widget.letters[index];
            return LetterCard(
              letter: letter,
            );
          },
          childCount: widget.letters.length,
        ),
      ),
    );
  }
}