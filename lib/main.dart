import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_version/get_version.dart';
import 'package:pnyws/app.dart';
import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/repositories/repository.dart';
import 'package:pnyws/services/auth/auth.dart';
import 'package:pnyws/services/session.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:pnyws/services/trip/trip.dart';
import 'package:pnyws/utils/mk_first_time_login_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main({
  Environment environment = Environment.MOCK,
  int delay = 0,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  final navigatorKey = GlobalKey<NavigatorState>();
  final sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());

  Repository repository;
  switch (environment) {
    case Environment.DEVELOPMENT:
    case Environment.PRODUCTION:
      repository = Repository(auth: AuthImpl(), trip: TripImpl());
      break;
    case Environment.MOCK:
    default:
      repository = Repository(auth: AuthMockImpl(), trip: TripMockImpl(pref: sharedPrefs));
  }

  Registry().initialize(
    repository,
    Session(environment: environment),
    navigatorKey,
    await GetVersion.projectVersion,
    sharedPrefs,
  );

  runApp(App(
    navigatorKey: navigatorKey,
    isFirstTime: MkFirstTimeLoginCheck.check(sharedPrefs, environment),
  ));
}
