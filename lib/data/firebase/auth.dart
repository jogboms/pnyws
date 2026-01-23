import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pnyws/data/entities/exceptions.dart';

class Auth {
  Auth(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  Stream<String?> get onAuthStateChanged => _auth.authStateChanges().map((user) => user?.uid);

  Future<void> signInWithGoogle() async {
    try {
      var account = await _googleSignIn.attemptLightweightAuthentication();
      account ??= await _googleSignIn.authenticate();

      final (idToken, accessToken) = (
        account.authentication.idToken,
        (await account.authorizationClient.authorizeScopes([])).accessToken,
      );

      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken),
      );
    } on PlatformException catch (e) {
      if (e case GoogleSignInException(code: .canceled)) {
        return;
      }
      if (e.message?.contains('administrator') ?? false) {
        throw Exception('It seems this account has been disabled. Contact an Admin.');
      }
      if (_containsAny(e.message ?? '', ['NETWORK_ERROR', 'network'])) {
        throw NoInternetException();
      }
      throw Exception('Sorry, We could not connect. Try again.');
    }
  }

  Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

bool _containsAny(String value, List<String> find) => find.fold(false, (acc, cur) => value.contains(cur));
