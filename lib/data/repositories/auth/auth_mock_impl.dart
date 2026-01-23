import 'package:pnyws/data/data.dart';

class AuthMockImpl extends AuthRepository {
  AuthMockImpl({required super.stateMachine});

  @override
  Stream<String> get onAuthStateChangedInternal => .value('1');

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}
}
