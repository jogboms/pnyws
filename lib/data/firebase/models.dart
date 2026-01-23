import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pnyws/data/firebase/data_reference.dart';

class FireSnapshot {
  FireSnapshot(DocumentSnapshot doc)
    : data = doc.data()! as Map<String, Object?>,
      reference = FireReference(doc.reference);

  final Map<String, Object?> data;

  final FireReference reference;
}

class FireUser {
  FireUser(this._reference);

  final User? _reference;

  String? get uuid => _reference?.uid;
}

class FireReference implements DataReference<DocumentReference> {
  FireReference(this._reference);

  final DocumentReference _reference;

  @override
  DocumentReference get source => _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) =>
      _reference.set(data, SetOptions(merge: merge));

  @override
  Future<void> updateData(Map<String, dynamic> data) => _reference.update(data);
}

class MockDataReference implements DataReference<dynamic> {
  @override
  Future<void> delete() async {}

  @override
  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) async {}

  @override
  dynamic get source => false;

  @override
  Future<void> updateData(Map<String, dynamic> data) async {}
}
