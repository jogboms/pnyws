import 'package:pnyws/models/primitives/account_data.dart';
import 'package:pnyws/repositories/auth/auth_repository.dart';

class AuthMockImpl implements AuthRepository {
  @override
  Stream<AccountData> getAccount(String uuid) async* {
    await Future<void>.delayed(const Duration(seconds: 0));
    yield AccountData(uuid: "1");
  }

  @override
  Stream<String> get onAuthStateChanged async* {
    yield "1";
  }

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp(AccountData account) async {}
}
