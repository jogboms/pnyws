import 'package:flutter/foundation.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/state/state_machine.dart';

import './auth_repository.dart';

class AuthMockImpl extends AuthRepository {
  AuthMockImpl({@required StateMachine stateMachine}) : super(stateMachine: stateMachine);

  @override
  Stream<AccountData> getAccount(String uuid) async* {
    await Future<void>.delayed(const Duration(seconds: 0));
    yield AccountData(uuid: "1");
  }

  @override
  Stream<String> get onAuthStateChangedInternal async* {
    yield "1";
  }

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUp(AccountData account) async {}
}
