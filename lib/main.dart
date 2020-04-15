import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_version/get_version.dart';
import 'package:pnyws/app.dart';
import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/repositories/repositories.dart';
import 'package:pnyws/services/services.dart';
import 'package:pnyws/state/state_machine.dart';
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
  final stateMachine = StateMachine();

  Repository repository;
  switch (environment) {
    case Environment.DEVELOPMENT:
    case Environment.PRODUCTION:
      {
        final firebase = Firebase();
        repository = Repository(
          auth: AuthImpl(firebase: firebase),
          trip: TripImpl(firebase: firebase, pref: sharedPrefs, stateMachine: stateMachine),
        );
        break;
      }
    case Environment.MOCK:
    default:
      repository = Repository(
        auth: AuthMockImpl(),
        trip: TripMockImpl(pref: sharedPrefs),
      );
  }

  Registry().initialize(
    repository,
    Session(environment: environment),
    navigatorKey,
    await GetVersion.projectVersion,
    sharedPrefs,
    stateMachine,
  );

  runApp(App(
    navigatorKey: navigatorKey,
    isFirstTime: MkFirstTimeLoginCheck.check(sharedPrefs, environment),
  ));
}
