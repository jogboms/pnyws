import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/primitives/account_data.dart';
import 'package:pnyws/repositories/auth_repository.dart';

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
    await firebase.db.account(account.uuid).updateData(account.toMap());
  }

  @override
  Stream<AccountData> getAccount(String uuid) {
    return firebase.db.account(uuid).snapshots().map((snapshot) {
      final json = FireSnapshot(snapshot).data;
      return AccountData(uuid: json["uuid"]);
    });
  }
}
