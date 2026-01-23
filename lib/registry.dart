import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:pnyws/coordinator/shared_coordinator.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/services/session.dart';
import 'package:pnyws/services/shared_prefs.dart';

class Registry {
  const Registry();

  void initialize(
    Repository repository,
    Session session,
    GlobalKey<NavigatorState> navigatorKey,
    String version,
    SharedPrefs sharedPrefs,
  ) {
    Injector.appInstance
      ..registerSingleton<Registry>(() => this)
      ..registerSingleton<Repository>(() => repository)
      ..registerSingleton<Session>(() => session)
      ..registerSingleton<SharedPrefs>(() => sharedPrefs)
      ..registerSingleton<_AppVersion>(() => _AppVersion(version))
      ..registerSingleton<SharedCoordinator>(() => SharedCoordinator(navigatorKey));
  }

  @visibleForTesting
  void dispose() {
    Injector.appInstance.clearAll();
  }

  static Registry di() => Injector.appInstance.get<Registry>();

  Repository get repository => Injector.appInstance.get<Repository>();

  Session get session => Injector.appInstance.get<Session>();

  String get version => Injector.appInstance.get<_AppVersion>().version;

  SharedPrefs get sharedPref => Injector.appInstance.get<SharedPrefs>();

  SharedCoordinator get sharedCoordinator => Injector.appInstance.get<SharedCoordinator>();
}

class _AppVersion {
  _AppVersion(this.version);

  final String version;
}
