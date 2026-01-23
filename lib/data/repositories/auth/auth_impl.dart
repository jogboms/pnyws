import 'package:pnyws/data/data.dart';
import 'package:rxdart/rxdart.dart';

class AuthImpl extends AuthRepository {
  AuthImpl({required this.firebase, required super.stateMachine});

  final Firebase firebase;

  @override
  Future<void> signIn() => firebase.auth.signInWithGoogle();

  @override
  Stream<String> get onAuthStateChangedInternal => firebase.auth.onAuthStateChanged.whereNotNull();

  @override
  Future<void> signOut() => firebase.auth.signOutWithGoogle();
}
