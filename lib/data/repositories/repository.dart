import 'package:flutter/foundation.dart';

import './auth/auth.dart';
import './trip/trip.dart';

class Repository {
  Repository({
    @required this.auth,
    @required this.trip,
  });

  final AuthRepository auth;
  final TripRepository trip;
}
