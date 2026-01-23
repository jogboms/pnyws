import 'package:equatable/equatable.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ExpenseData with EquatableMixin {
  ExpenseData({
    String? uuid,
    required this.title,
    this.accountID,
    this.description = '',
    this.value = 0.0,
    this.tripID,
    DateTime? createdAt,
  }) : uuid = uuid ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  factory ExpenseData.fromMap(Map<String, Object?> map) => ExpenseData(
    uuid: map['uuid']! as String,
    title: map['title']! as String,
    value: map['value'] as double? ?? 0.0,
    tripID: map['tripID'] as String?,
    description: map['description']! as String,
    accountID: map['accountID'] as String?,
    createdAt: parseDateTime(map['createdAt']! as String),
  );

  final String uuid;
  final String title;
  final String? tripID;
  final String description;
  final String? accountID;
  final double value;
  final DateTime createdAt;

  bool get isValid => title.isNotEmpty && value > 0;

  @override
  List<Object?> get props => [
    uuid,
    title,
    tripID,
    description,
    accountID,
    value,
    createdAt,
  ];

  Map<String, Object?> toMap() => {
    'uuid': uuid,
    'title': title,
    'value': value,
    'accountID': accountID,
    'tripID': tripID,
    'description': description,
    'createdAt': createdAt.toString(),
  };
}
