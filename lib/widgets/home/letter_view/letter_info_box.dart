import 'package:flutter/material.dart';
import 'package:naro/styles/text_styles.dart';

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
              Text(title, style: AppTextStyles.letterCardTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              Text('$arrivalAt 도착', style: AppTextStyles.letterCardArrivalDateStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              // Text(dDay == null ? '도착완료' : 'D-$dDay', style: letterCardDdayStyle),
              Text(dDayText, style: AppTextStyles.letterCardDdayStyle),
            ]
          ),
        ),
      ),
    );
  }
}