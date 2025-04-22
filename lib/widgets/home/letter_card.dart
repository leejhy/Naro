import 'package:flutter/material.dart';

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
    final letter = widget.letter;
    final dDay = calculateDday(DateTime.parse(letter['arrival_at']));

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
return Card(
  color: const Color.fromARGB(255, 255, 255, 255),
  shadowColor: const Color.fromARGB(82, 0, 0, 0),
  elevation: 2,
  child: InkWell(
    onTap: () {
      print('asdads');
    },
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = (constraints.maxHeight) + 24;
          final cardWidth = (constraints.maxWidth) + 24;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: cardHeight * 0.41, // Card 내부 높이의 절반
                width: cardWidth * 0.72,
                decoration: BoxDecoration(
                  color: Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.mail_outline, size: 24, color: Colors.black54),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: cardWidth * 0.72,
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
          );
        },
      ),
    ),
  ),
);
  }
}