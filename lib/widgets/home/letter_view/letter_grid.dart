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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.84,
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