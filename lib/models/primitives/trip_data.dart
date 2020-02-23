import 'package:flutter/foundation.dart';
import 'package:pnyws/models/primitives/expense_data.dart';

class TripData {
  TripData({
    @required this.title,
    @required this.items,
    @required this.createdAt,
  });

  final String title;
  final List<ExpenseData> items;
  final DateTime createdAt;

  @override
  int get hashCode => title.hashCode ^ items.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TripData && other.title == title && other.items == items && other.createdAt.compareTo(createdAt) == 0;

  @override
  String toString() {
    return "{title: $title, items: $items, createdAt: $createdAt}";
  }
}
