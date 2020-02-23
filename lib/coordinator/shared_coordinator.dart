import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_routes.dart';
import 'package:pnyws/coordinator/coordinator_base.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/screens/dashboard/dashboard_page.dart';
import 'package:pnyws/screens/home/home_page.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/wrappers/mk_navigate.dart';

@immutable
class SharedCoordinator extends CoordinatorBase {
  const SharedCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toDashboard({TripData selectedTrip}) {
    navigator?.push<void>(MkNavigate.fadeIn(DashboardPage(selectedTrip: selectedTrip), fullscreenDialog: true));
  }

  void toHome() {
    navigator?.pushAndRemoveUntil(
      MkNavigate.fadeIn(HomePage(), name: MkRoutes.start),
      (Route<void> route) => false,
    );
  }

  void toSplash() {
    navigator?.pushAndRemoveUntil(
      MkNavigate.fadeIn(SplashPage(), name: MkRoutes.start),
      (Route<void> route) => false,
    );
  }
}
