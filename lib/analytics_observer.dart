// analytics_observer.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  final FirebaseAnalytics analytics;

  AnalyticsRouteObserver(this.analytics);

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendScreenView(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendScreenView(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _sendScreenView(Route? route) {
    final screenName = route?.settings.name ?? route?.settings.toString() ?? 'unknown';
    analytics.logScreenView(screenName: screenName);
  }
}