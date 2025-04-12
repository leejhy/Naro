import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/screens/home.dart';
import 'package:naro/screens/writing.dart';
import 'package:naro/screens/test.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) {
        return Test();
      },
    ),
    GoRoute(
      path: '/writing',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          // transitionDuration: const Duration(milliseconds: 400),
          child: const WritingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0, 1);
            const end = Offset.zero;
            const curve = Curves.easeOut;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
    ),
  ]
);
