import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/styles/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naro/utils/utils.dart';

class WritingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String arrivalDate;
  final VoidCallback onTapCalendar;

  const WritingAppBar({
    required this.arrivalDate,
    required this.onTapCalendar,
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    if (arrivalDate.isEmpty) {
      return AppBar(
        centerTitle: true,
        backgroundColor: UIColors.white,
        surfaceTintColor: UIColors.white,
        title: Text("writing.select_date".tr(), style: AppTextStyles.writingAppbar,),
        elevation: 2,
      );
    }
    final dateString = getLocalizedDateString(DateTime.parse(arrivalDate), context);
    return AppBar(
      centerTitle: true,
      backgroundColor: UIColors.white,
      surfaceTintColor: UIColors.white,
      elevation: 2,
      shadowColor: UIColors.appbarShadow,
      title: GestureDetector(
        onTap: onTapCalendar,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'writing.title'.tr(namedArgs: {'date':dateString}),
              style: AppTextStyles.writingAppbar,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_month_rounded, size: 22, color: UIColors.black),
          ],
        ),
      ),
    );
  }
}