import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ExpenseData {
  ExpenseData({
    String id,
    @required this.title,
    this.accountID,
    this.description = "",
    this.value = 0.0,
    this.tripID,
    DateTime createdAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  final String tripID;
  final String description;
  final String accountID;
  final double value;
  final DateTime createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ accountID.hashCode ^ value.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ExpenseData &&
      other.id == id &&
      other.title == title &&
      other.accountID == accountID &&
      other.value == value &&
      other.createdAt.compareTo(createdAt) == 0;

  bool get isValid => title != null && title.isNotEmpty && value > 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uuid": id,
      "title": title,
      "value": value,
      "accountID": accountID,
      "tripID": tripID,
      "description": description,
      "createdAt": createdAt.toString(),
    };
  }

  @override
  String toString() {
    return "{id: $id, title: $title, description: $description, tripID: $tripID, accountID: $accountID, value: $value, createdAt: $createdAt}";
  }
}
