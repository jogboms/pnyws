import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pnyws/firebase/auth.dart';
import 'package:pnyws/firebase/cloud_db.dart';

class Firebase {
  factory Firebase() {
    return Firebase._(
      db: CloudDb(Firestore.instance),
      auth: Auth(FirebaseAuth.instance, GoogleSignIn()),
    );
  }

  const Firebase._({
    @required this.db,
    @required this.auth,
  }) : assert(db != null && auth != null);

  final CloudDb db;
  final Auth auth;
}
