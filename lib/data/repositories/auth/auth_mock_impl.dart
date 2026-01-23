import 'package:pnyws/data/data.dart';

class AuthMockImpl extends AuthRepository {
  AuthMockImpl({required super.stateMachine});

  @override
  Stream<AccountData> getAccount(String uuid) async* {
    await Future<void>.delayed(.zero);
    yield AccountData(uuid: '1');
  }

  @override
  Stream<String> get onAuthStateChangedInternal async* {
    yield '1';
  }

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp(AccountData account) async {}
}
