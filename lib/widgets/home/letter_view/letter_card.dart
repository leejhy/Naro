import 'package:flutter/material.dart';
import 'package:naro/widgets/home/letter_view/letter_icon_box.dart';

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
    //todo: Move TextStyle definitions outside of build method
    final titleStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    );

    final dDayStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    );

    final arrivalDateStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: -0.1,
      color: Color(0xff6B7280),
    );

    final letter = widget.letter;
    final dDay = calculateDday(DateTime.parse(letter['arrival_at']));
    final bool isOpened = dDay == null || dDay == 'Day';
    const double cardWidth = 0.72;
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      shadowColor: const Color.fromARGB(82, 0, 0, 0),
      elevation: 2,
      child: InkWell(
        onTap: () {
          print('asdads');
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
                //todo 지금당장이거 아래꺼 widget화하기
                Expanded(
                  flex: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: FractionallySizedBox(
                      widthFactor: cardWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(letter['title'], style: titleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          Text('${letter['arrival_at']} 도착', style: arrivalDateStyle,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          Text(dDay == null ? '도착완료' : 'D-$dDay', style: dDayStyle),
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}