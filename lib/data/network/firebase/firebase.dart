import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';
import 'cloud_db.dart';

export 'data_reference.dart';
export 'models.dart';

class Firebase {
  const Firebase._({
    @required this.db,
    @required this.auth,
  }) : assert(db != null && auth != null);

  static Future<Firebase> initialize() async {
    await firebase.Firebase.initializeApp();
    return Firebase._(
      db: CloudDb(FirebaseFirestore.instance),
      auth: Auth(FirebaseAuth.instance, GoogleSignIn()),
    );
  }

  final CloudDb db;
  final Auth auth;
}
