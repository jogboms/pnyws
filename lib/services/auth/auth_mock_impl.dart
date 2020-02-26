import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/account.dart';
import 'package:pnyws/repositories/auth_repository.dart';

class AuthMockImpl implements AuthRepository {
  @override
  Stream<AccountModel> getAccount(String uuid) async* {
    await Future<void>.delayed(const Duration(seconds: 0));
    yield AccountModel(uuid: 1, reference: MockDataReference());
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
  Future<void> signUp(AccountModel account) async {}
}
