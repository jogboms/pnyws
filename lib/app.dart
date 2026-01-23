import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:pnyws/constants/mk_routes.dart';
import 'package:pnyws/constants/mk_strings.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class App extends StatelessWidget {
  const App({super.key, required this.navigatorKey, required this.isFirstTime, this.navigatorObservers});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final List<NavigatorObserver>? navigatorObservers;

  @override
  Widget build(BuildContext context) => ScaleAware(
    config: const ScaleConfig(width: 375, height: 812),
    child: ThemeProvider(
      child: Builder(
        builder: (BuildContext context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: MkStrings.appName,
          color: Colors.white,
          navigatorKey: navigatorKey,
          navigatorObservers: navigatorObservers ?? [],
          theme: ThemeProvider.of(context).themeData(Theme.of(context)),
          onGenerateRoute: (RouteSettings settings) => _PageRoute(
            builder: (_) => isFirstTime || Registry.di().session.isMock ? const SplashPage() : const SplashPage(),
            settings: RouteSettings(name: MkRoutes.start, arguments: settings.arguments),
          ),
        ),
      ),
    ),
  );
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(_, Animation<double> animation, _, Widget child) => FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
      child: child,
    ),
  );
}
