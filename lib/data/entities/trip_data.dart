import 'package:equatable/equatable.dart';
import 'package:pnyws/data/entities/expense_data.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:uuid/uuid.dart';

class TripData with EquatableMixin {
  TripData({
    String? uuid,
    required this.title,
    this.accountID,
    this.description = '',
    this.items = const [],
    DateTime? createdAt,
  }) : uuid = uuid ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  factory TripData.fromMap(Map<String, Object?> map, Map<String, List<ExpenseData>> expenses) => TripData(
    uuid: map['uuid']! as String,
    title: map['title']! as String,
    description: map['description']! as String,
    accountID: map['accountID'] as String?,
    createdAt: parseDateTime(map['createdAt']! as String),
    items: (expenses[map['uuid']] ?? [])..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
  );

  final String uuid;
  final String title;
  final String description;
  final String? accountID;
  final List<ExpenseData> items;
  final DateTime createdAt;

  bool get isValid => title.isNotEmpty;

  @override
  List<Object?> get props => [uuid, title, description, accountID, items, createdAt];

  TripData copyWith({
    String? title,
    String? description,
    List<ExpenseData>? items,
  }) => TripData(
    uuid: uuid,
    createdAt: createdAt,
    accountID: accountID,
    title: title ?? this.title,
    description: description ?? this.description,
    items: items ?? this.items,
  );

  Map<String, Object?> toMap() => {
    'uuid': uuid,
    'title': title,
    'accountID': accountID,
    'description': description,
    'createdAt': createdAt.toString(),
  };
}
