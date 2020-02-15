import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/services/shared_prefs.dart';

const _isFirstTimeLogin = "IS_FIRST_TIME_LOGIN";

class MkFirstTimeLoginCheck {
  static bool check(SharedPrefs sharedPrefs, Environment env) {
    if (env.isMock) {
      return true;
    }
    final state = sharedPrefs.getBool(_isFirstTimeLogin);
    if (state != false) {
      return true;
    }
    return false;
  }
}
