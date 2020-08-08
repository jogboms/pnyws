import 'package:flutter/foundation.dart';

class AccountData {
  AccountData({@required this.uuid});

  final String uuid;

  Map<String, String> toMap() {
    return <String, String>{"uuid": uuid};
  }

  @override
  String toString() {
    return "{uuid: $uuid}";
  }
}
