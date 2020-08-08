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
    assert(session != null && navigatorKey != null);
    Injector.appInstance
      ..registerSingleton<Registry>((_) => this)
      ..registerSingleton<Repository>((_) => repository)
      ..registerSingleton<Session>((_) => session)
      ..registerSingleton<SharedPrefs>((_) => sharedPrefs)
      ..registerSingleton<_AppVersion>((_) => _AppVersion(version))
      ..registerSingleton<SharedCoordinator>((_) => SharedCoordinator(navigatorKey));
  }

  @visibleForTesting
  void dispose() {
    Injector.appInstance.clearAll();
  }

  static Registry di() => Injector.appInstance.getDependency<Registry>();

  Repository get repository => Injector.appInstance.getDependency<Repository>();

  Session get session => Injector.appInstance.getDependency<Session>();

  String get version => Injector.appInstance.getDependency<_AppVersion>().version;

  SharedPrefs get sharedPref => Injector.appInstance.getDependency<SharedPrefs>();

  SharedCoordinator get sharedCoordinator => Injector.appInstance.getDependency<SharedCoordinator>();
}

class _AppVersion {
  _AppVersion(this.version);

  final String version;
}
