import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/repositories/trip_repository.dart';

class TripImpl implements TripRepository {
  @override
  Stream<TripData> getActiveTrip() {
    throw UnimplementedError();
  }

  @override
  Stream<List<TripData>> getAllTrips() {
    throw UnimplementedError();
  }

  @override
  void setActiveTrip(TripData trip) {
    throw UnimplementedError();
  }

  @override
  void addNewTrip(TripData trip) {
    throw UnimplementedError();
  }
}
