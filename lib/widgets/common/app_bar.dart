import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TitleAppBar({
    super.key,
    required this.title,
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
      title: Text(title, style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      )),
    );
  }
}