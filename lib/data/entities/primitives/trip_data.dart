import 'package:flutter/foundation.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:uuid/uuid.dart';

import 'expense_data.dart';

class TripData {
  TripData({
    String uuid,
    @required this.title,
    this.accountID,
    this.description = "",
    this.items = const [],
    DateTime createdAt,
  })  : uuid = uuid ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  final String uuid;
  final String title;
  final String description;
  final String accountID;
  final List<ExpenseData> items;
  final DateTime createdAt;

  @override
  int get hashCode =>
      uuid.hashCode ^ title.hashCode ^ description.hashCode ^ accountID.hashCode ^ items.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is TripData &&
      other.uuid == uuid &&
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
      uuid: uuid,
      createdAt: createdAt,
      accountID: accountID,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uuid": uuid,
      "title": title,
      "accountID": accountID,
      "description": description,
      "createdAt": createdAt.toString(),
    };
  }

  @override
  String toString() {
    return "{uuid: $uuid, title: $title, description: $description, accountID: $accountID items: $items, createdAt: $createdAt}";
  }
}
