import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/screens/home.dart';
import 'package:naro/screens/letters.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Home();
      },
    ),
    GoRoute(
      path: '/letter',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          // transitionDuration: const Duration(milliseconds: 400),
          child: const Test(),
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
