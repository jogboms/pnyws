import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/repositories/auth_repository.dart';

class AuthImpl implements AuthRepository {
  AuthImpl({@required this.firebase});

  final Firebase firebase;

  @override
  Future<Map<String, int>> getAccount() async {
    throw UnimplementedError();
  }
}
