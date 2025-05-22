import 'package:flutter/material.dart';
import 'package:naro/router.dart';
import 'package:naro/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DatabaseHelper.database;
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously();
  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final initialLocale = deviceLocale.languageCode == 'ko'
      ? const Locale('ko')
      : const Locale('en');
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ko')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: initialLocale,
      child: ProviderScope(child: const MyApp())
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Naro - 미래의 나에게 쓰는 편지',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
