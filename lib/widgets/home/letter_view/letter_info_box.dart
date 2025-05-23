import 'package:flutter/material.dart';
import 'package:naro/styles/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naro/utils/utils.dart';

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
    if (dDay < 0) return 'letter.arrived'.tr();
    if (dDay == 0) return 'D-Day';
    return 'D-$dDay';
  }

  @override
  Widget build(BuildContext context) {
    final dateString = getLocalizedDateString(DateTime.parse(arrivalAt), context);
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
              Text(
                'letter.arrival_date'.tr(namedArgs: {'date': dateString}),
                style: AppTextStyles.letterCardArrivalDateStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              Text(dDayText, style: AppTextStyles.letterCardDdayStyle),
            ]
          ),
        ),
      ),
    );
  }
}