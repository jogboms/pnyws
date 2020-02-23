import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ExpenseData {
  ExpenseData({
    String id,
    @required this.title,
    @required this.value,
    @required this.createdAt,
  }) : id = id ?? Uuid().v4();

  final String id;
  final String title;
  final double value;
  final DateTime createdAt;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ value.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ExpenseData &&
      other.id == id &&
      other.title == title &&
      other.value == value &&
      other.createdAt.compareTo(createdAt) == 0;

  @override
  String toString() {
    return "{id: $id, title: $title, value: $value, createdAt: $createdAt}";
  }
}
