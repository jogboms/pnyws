import 'package:equatable/equatable.dart';

class AccountData with EquatableMixin {
  AccountData({required this.uuid});

  final String uuid;

  @override
  List<Object?> get props => [uuid];

  Map<String, String> toMap() => {'uuid': uuid};
}
