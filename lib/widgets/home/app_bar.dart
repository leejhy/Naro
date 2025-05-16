import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/styles/colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shadowColor: UIColors.appbarShadow,
      color: UIColors.white,
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo/home_icon.png', width: 58, height: 38),
              IconButton(
                onPressed: () {
                  context.push('/setting');
                },
                icon: Icon(Icons.settings, size: 24)
              ),
            ]
          ),
        ),
      ),
    );
  }
}