import 'package:pnyws/models/account.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();

  Stream<String> get onAuthStateChanged;

  Future<void> signOut();

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount(String uuid);
}
