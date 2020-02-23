import 'package:flutter/foundation.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:uuid/uuid.dart';

class TripData {
  TripData({
    String id,
    @required this.title,
    @required this.items,
    @required this.createdAt,
  }) : id = id ?? Uuid().v4();

  final String id;
  final String title;
  final List<ExpenseData> items;
  final DateTime createdAt;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ items.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TripData &&
      other.id == id &&
      other.title == title &&
      other.items == items &&
      other.createdAt.compareTo(createdAt) == 0;

  @override
  String toString() {
    return "{id: $id, title: $title, items: $items, createdAt: $createdAt}";
  }
}
