import 'package:flutter/material.dart';

class LetterInfoBox extends StatelessWidget {
  const LetterInfoBox({
    super.key,
    required this.title,
    required this.arrivalAt,
    required this.dDay,
    required this.widthFactor,
    required this.flex,
  });

  final String title;
  final String arrivalAt;
  final int dDay;
  final double? widthFactor;
  final int flex;
  String get dDayText {
    if (dDay < 0) return '도착완료';
    if (dDay == 0) return 'D-Day';
    return 'D-$dDay';
  }

  @override
  Widget build(BuildContext context) {
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

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              Text('$arrivalAt 도착', style: arrivalDateStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              // Text(dDay == null ? '도착완료' : 'D-$dDay', style: dDayStyle),
              Text(dDayText, style: dDayStyle),
            ]
          ),
        ),
      ),
    );
  }
}