import 'package:cloud_firestore/cloud_firestore.dart';

extension type FireSnapshot._(Map<String, Object?> _data) implements Map<String, Object?> {
  factory FireSnapshot(DocumentSnapshot doc) => FireSnapshot._(doc.data()! as Map<String, Object?>);
}
