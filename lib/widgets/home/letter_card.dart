import 'package:flutter/material.dart';


class LetterCard extends StatefulWidget {
  final List<Map<String, dynamic>> letters;

  const LetterCard({
    super.key,
    required this.letters,
  });

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard> {

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
            final dDay = calculateDday(DateTime.parse(letter['arrival_at']));
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(letter['title']!, style: titleStyle),
                    SizedBox(height: 8),
                    Text('${letter['arrival_at']} 도착', style: dateStyle),
                    SizedBox(height: 8),
                    Text(
                      dDay == null ? '도착완료' : 'D-$dDay',
                      style: dDayStyle
                    ),
                  ],
                ),
              )
            );
          },
          childCount: widget.letters.length,
        ),
      ),
    );
  }
}