import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pnyws/data/firebase/auth.dart';
import 'package:pnyws/data/firebase/cloud_db.dart';

export 'data_reference.dart';
export 'models.dart';

class Firebase {
  const Firebase._({
    required this.db,
    required this.auth,
  });

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
