import 'package:flutter/material.dart';
import 'package:naro/styles/text_styles.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:naro/utils/utils.dart';

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
  late final String randomKey;

  @override
  void initState() {
    super.initState();
    final List<String> keys = List.generate(7, (i) => 'no_letter_$i');
    randomKey = keys[Random().nextInt(keys.length)];
  }

  @override
  Widget build(BuildContext context) {
    final dDay = widget.dDay;
    final arrivalDate = getLocalizedDateString(widget.arrivalDate, context);
    // print(getLocalizedDateString(widget.arrivalDate, context));
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
                Text('header.upcoming'.tr(), style: AppTextStyles.headingStyle),
                Text('header.d_day'.tr(namedArgs: {'day': dDay.toString()}), style: AppTextStyles.dDayStyle),
                SizedBox(height: 4),
                Text('header.arrival_date'.tr(namedArgs: {
                  'date': arrivalDate,
                }), style: AppTextStyles.dateStyle),
              ] else if (dDay == 0)... [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'header.today_arrival'.tr(),
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
                      randomKey.tr(),
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