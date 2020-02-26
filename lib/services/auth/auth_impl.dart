import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/account.dart';
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
  Future<void> signUp(AccountModel account) async {
    await account.reference.updateData(account.toMap());
  }

  @override
  Stream<AccountModel> getAccount(String uuid) {
    return firebase.db.account(uuid).snapshots().map((snapshot) {
      final s = FireSnapshot(snapshot);
      return AccountModel.fromJson(s.data, s.reference);
    });
  }
}
