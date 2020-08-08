import 'package:flutter/foundation.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/state/state_machine.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthRepository {
  AuthRepository({@required this.stateMachine});

  final StateMachine stateMachine;

  Future<void> signInWithGoogle();

  Stream<String> get onAuthStateChanged => onAuthStateChangedInternal
      .doOnData((uuid) => stateMachine.add((state) => state.copyWith(account: AccountData(uuid: uuid))));

  Stream<String> get onAuthStateChangedInternal;

  Future<void> signOut();

  Future<void> signUp(AccountData account);

  Stream<AccountData> getAccount(String uuid);
}
