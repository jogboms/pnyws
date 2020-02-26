import 'package:flutter/foundation.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:uuid/uuid.dart';

class TripData {
  TripData({
    String id,
    @required this.title,
    this.accountID,
    this.description = "",
    this.items = const [],
    DateTime createdAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String description;
  final String accountID;
  final List<ExpenseData> items;
  final DateTime createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ accountID.hashCode ^ items.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TripData &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.accountID == accountID &&
      other.items == items &&
      other.createdAt.compareTo(createdAt) == 0;

  bool get isValid => title != null && title.isNotEmpty;

  TripData copyWith({
    String title,
    String description,
    List<ExpenseData> items,
  }) {
    return TripData(
      id: id,
      createdAt: createdAt,
      accountID: accountID,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uuid": id,
      "title": title,
      "accountID": accountID,
      "description": description,
      "createdAt": createdAt.toString(),
    };
  }

  @override
  String toString() {
    return "{id: $id, title: $title, description: $description, accountID: $accountID items: $items, createdAt: $createdAt}";
  }
}
