import 'package:flutter/foundation.dart';

class ExpenseData {
  const ExpenseData({
    @required this.title,
    @required this.value,
    @required this.createdAt,
  });

  final String title;
  final double value;
  final DateTime createdAt;

  @override
  int get hashCode => title.hashCode ^ value.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ExpenseData && other.title == title && other.value == value && other.createdAt.compareTo(createdAt) == 0;

  @override
  String toString() {
    return "{title: $title, value: $value, createdAt: $createdAt}";
  }
}
