import 'package:flutter/foundation.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ExpenseData {
  ExpenseData({
    String uuid,
    @required this.title,
    this.accountID,
    this.description = "",
    this.value = 0.0,
    this.tripID,
    DateTime createdAt,
  })  : uuid = uuid ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory ExpenseData.fromMap(Map<String, dynamic> map) {
    return ExpenseData(
      uuid: map["uuid"],
      title: map["title"],
      value: map["value"] ?? 0.0,
      tripID: map["tripID"],
      description: map["description"],
      accountID: map["accountID"],
      createdAt: parseDateTime(map["createdAt"]),
    );
  }

  final String uuid;
  final String title;
  final String tripID;
  final String description;
  final String accountID;
  final double value;
  final DateTime createdAt;

  @override
  int get hashCode =>
      uuid.hashCode ^ title.hashCode ^ description.hashCode ^ accountID.hashCode ^ value.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ExpenseData &&
      other.uuid == uuid &&
      other.title == title &&
      other.accountID == accountID &&
      other.value == value &&
      other.createdAt.compareTo(createdAt) == 0;

  bool get isValid => title != null && title.isNotEmpty && value > 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uuid": uuid,
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
    return "{uuid: $uuid, title: $title, description: $description, tripID: $tripID, accountID: $accountID, value: $value, createdAt: $createdAt}";
  }
}
