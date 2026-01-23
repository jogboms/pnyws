import 'package:pnyws/data/repositories/auth/auth_repository.dart';
import 'package:pnyws/data/repositories/trip/trip_repository.dart';

final class Repository {
  const Repository({required this.auth, required this.trip});

  final AuthRepository auth;
  final TripRepository trip;
}
