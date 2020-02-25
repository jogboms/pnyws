import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireSnapshot {
  FireSnapshot(DocumentSnapshot doc)
      : data = doc.data,
        reference = FireReference(doc.reference);

  final Map<String, dynamic> data;

  final FireReference reference;
}

class FireUser {
  FireUser(this._reference);

  final FirebaseUser _reference;

  String get uuid => _reference?.uid;
}

class FireReference {
  FireReference(this._reference);

  final DocumentReference _reference;

  DocumentReference get source => _reference;

  Future<void> delete() => _reference.delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) => _reference.setData(data, merge: merge);

  Future<void> updateData(Map<String, dynamic> data) => _reference.updateData(data);
}
