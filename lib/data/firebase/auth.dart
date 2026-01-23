import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pnyws/data/entities/exceptions.dart';
import 'package:pnyws/data/firebase/models.dart';

class Auth {
  Auth(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FireUser get getUser => FireUser(_auth.currentUser);

  Stream<FireUser> get onAuthStateChanged => _auth.authStateChanges().map(FireUser.new);

  Future<void> signInWithGoogle() async {
    try {
      var currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();

      final auth = await currentUser?.authentication;
      if (auth == null) {
        throw Exception('Authentication failed. Please try again.');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kSignInCanceledError) {
        return;
      }
      if (e.message?.contains('administrator') ?? false) {
        throw Exception('It seems this account has been disabled. Contact an Admin.');
      }
      if (_containsAny(e.message ?? '', ['NETWORK_ERROR', 'network'])) {
        throw NoInternetException();
      }
      throw Exception('Sorry, We could not connect. Try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

bool _containsAny(String value, List<String> find) => find.fold(false, (acc, cur) => value.contains(cur));
