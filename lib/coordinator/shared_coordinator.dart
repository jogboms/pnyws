import 'package:flutter/material.dart';
import 'package:pnyws/coordinator/coordinator_base.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/screens/dashboard/dashboard_page.dart';
import 'package:pnyws/screens/home/home_page.dart';
import 'package:pnyws/screens/splash/splash_page.dart';

@immutable
class SharedCoordinator extends CoordinatorBase {
  const SharedCoordinator(super.navigatorKey);

  void toDashboard({TripData? selectedTrip}) =>
      navigator?.push<void>(_fadeIn(DashboardPage(selectedTrip: selectedTrip), fullscreenDialog: true));

  void toHome() => navigator?.pushAndRemoveUntil(
    _fadeIn(const HomePage(), name: '/'),
    (route) => false,
  );

  void toSplash() => navigator?.pushAndRemoveUntil(
    _fadeIn(const SplashPage(), name: '/'),
    (route) => false,
  );
}

PageRoute<T> _fadeIn<T extends Object>(Widget widget, {String? name, bool fullscreenDialog = false}) =>
    PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, _, _) => widget,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
      settings: name != null ? RouteSettings(name: name) : null,
      fullscreenDialog: fullscreenDialog,
    );
