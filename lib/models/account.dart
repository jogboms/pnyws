import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/data_reference.dart';

class AccountModel {
  AccountModel({@required this.uuid, this.reference});

  final String uuid;
  final DataReference reference;

  static AccountModel fromJson(Map<String, dynamic> map, DataReference reference) {
    return AccountModel(
      uuid: map["uuid"],
      reference: reference,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"uuid": uuid};
  }

  @override
  String toString() {
    return "{uuid: $uuid}";
  }
}
