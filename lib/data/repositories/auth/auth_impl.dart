import 'package:pnyws/data/data.dart';
import 'package:rxdart/rxdart.dart';

class AuthImpl extends AuthRepository {
  AuthImpl({required this.firebase, required super.stateMachine});

  final Firebase firebase;

  @override
  Future<void> signIn() => firebase.auth.signInWithGoogle();

  @override
  Stream<String> get onAuthStateChangedInternal =>
      firebase.auth.onAuthStateChanged.map((convert) => convert.uuid).whereNotNull();

  @override
  Future<void> signOut() => firebase.auth.signOutWithGoogle();

  @override
  Future<void> signUp(AccountData account) async {
    await firebase.db.accounts.fetchOne(account.uuid).update(account.toMap());
  }

  @override
  Stream<AccountData> getAccount(String uuid) => firebase.db.accounts.fetchOne(uuid).snapshots().map((snapshot) {
    final json = FireSnapshot(snapshot).data;
    return AccountData(uuid: json['uuid']! as String);
  });
}
