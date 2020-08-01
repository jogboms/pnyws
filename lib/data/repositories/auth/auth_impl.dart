import 'package:flutter/foundation.dart';
import 'package:pnyws/data/data.dart';

import './auth_repository.dart';

class AuthImpl implements AuthRepository {
  AuthImpl({@required this.firebase});

  final Firebase firebase;

  @override
  Future<void> signInWithGoogle() => firebase.auth.signInWithGoogle();

  @override
  Stream<String> get onAuthStateChanged => firebase.auth.onAuthStateChanged.map((convert) => convert.uuid);

  @override
  Future<void> signOut() => firebase.auth.signOutWithGoogle();

  @override
  Future<void> signUp(AccountData account) async {
    await firebase.db.accounts.fetchOne(account.uuid).update(account.toMap());
  }

  @override
  Stream<AccountData> getAccount(String uuid) {
    return firebase.db.accounts.fetchOne(uuid).snapshots().map((snapshot) {
      final json = FireSnapshot(snapshot).data;
      return AccountData(uuid: json["uuid"]);
    });
  }
}
