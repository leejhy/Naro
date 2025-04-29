import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/widgets/home/letter_view/letter_icon_box.dart';
import 'package:naro/widgets/home/letter_view/letter_info_box.dart';
import 'package:naro/utils.dart';

class LetterCard extends StatefulWidget {
  const LetterCard({
    super.key,
    required this.letter,
  });
  final Map<String, dynamic> letter;

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard> {


  @override
  Widget build(BuildContext context) {
    //todo: Move TextStyle definitions outside of build method
    final dDay = calculateDday(DateTime.parse(widget.letter['arrival_at']));
    // print('letter dday: $dDay');
    // print('arrivalAt: ${widget.letter['arrival_at']}');
    //dday < 0, dday == 0, dday > 0
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
        onTap: () {
          context.push('/letter/${widget.letter['id']}');
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