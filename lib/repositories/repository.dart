import 'package:flutter/foundation.dart';
import 'package:pnyws/repositories/auth_repository.dart';

class Repository {
  Repository({
    @required this.auth,
  });

  final AuthRepository auth;
}
