import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/styles/text_styles.dart';

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
    return AppBar(
      centerTitle: true,
      backgroundColor: UIColors.white,
      surfaceTintColor: UIColors.white,
      elevation: 2,
      shadowColor: UIColors.appbarShadow,
      //todo title만 따로 받기
      title: GestureDetector(
        onTap: onTapCalendar,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '도착: $arrivalDate',
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