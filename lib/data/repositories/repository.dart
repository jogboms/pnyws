import 'package:pnyws/data/repositories/auth/auth.dart';
import 'package:pnyws/data/repositories/trip/trip.dart';

class Repository {
  Repository({
    required this.auth,
    required this.trip,
  });

  final AuthRepository auth;
  final TripRepository trip;
}
