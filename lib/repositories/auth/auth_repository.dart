import 'package:pnyws/models/primitives/account_data.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();

  Stream<String> get onAuthStateChanged;

  Future<void> signOut();

  Future<void> signUp(AccountData account);

  Stream<AccountData> getAccount(String uuid);
}
