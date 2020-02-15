import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:pnyws/constants/mk_routes.dart';
import 'package:pnyws/constants/mk_strings.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.navigatorKey,
    @required this.isFirstTime,
    this.navigatorObservers,
  }) : super(key: key);

  final List<NavigatorObserver> navigatorObservers;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    return ScaleAware(
      config: ScaleConfig(width: 375, height: 812),
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
              builder: (_) => isFirstTime || Registry.di().session.isMock ? SplashPage() : SplashPage(),
              settings: settings.copyWith(name: MkRoutes.start),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}
