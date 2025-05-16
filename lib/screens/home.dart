import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/services/firebase_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:naro/utils/ad_manager.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/home/app_bar.dart';
import 'package:naro/widgets/home/body.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final FirebaseAnalytics analytics;

  @override
  void initState() {
    super.initState();
    analytics = ref.read(firebaseAnalyticsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initAppTracking();
      AdManager.instance.loadRewardedAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColors.white,
      appBar: HomeAppBar(),
      body: HomeBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            backgroundColor: UIColors.black,
            onPressed: () {
              context.push('/writing');
            },
            child: const Icon(Icons.add, color: UIColors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
