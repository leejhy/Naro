import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/analytics_observer.dart';
import 'package:naro/screens/home.dart';
import 'package:naro/screens/setting.dart';
import 'package:naro/screens/writing.dart';
import 'package:naro/screens/test.dart';
import 'package:naro/screens/result.dart';
import 'package:naro/screens/letter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


final GoRouter router = GoRouter(
  observers: [AnalyticsRouteObserver(FirebaseAnalytics.instance)],
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'HomeScreen',
      builder: (context, state) {
        // FirebaseAnalytics.instance.logScreenView(screenName: 'SettingScreen');
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
      path: '/result/:id',
      name: 'ResultScreen',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ResultScreen(letterId: id!);
      },
    ),
    GoRoute(
      path: '/letter/:id',
      name: 'LetterScreen',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return LetterScreen(letterId: id!);
      },
    ),
    GoRoute(
      path: '/setting',
      name: 'SettingScreen',
      builder: (context, state) {
        return SettingScreen();
      },
    ),
    GoRoute(
      path: '/writing',
      name: 'WritingScreen',
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
