import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naro/services/firebase_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:naro/utils/ad_manager.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/widgets/common/icon_fab.dart';
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
      floatingActionButton: IconFab(
        icon: const Icon(Icons.add, color: UIColors.white, size: 30),
        onPressed: () => context.push('/writing'),
      ),
    );
  }
}
