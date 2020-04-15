import 'package:flutter/foundation.dart';
import 'package:pnyws/repositories/auth/auth_repository.dart';
import 'package:pnyws/repositories/trip/trip_repository.dart';

class Repository {
  Repository({
    @required this.auth,
    @required this.trip,
  });

  final AuthRepository auth;
  final TripRepository trip;
}
