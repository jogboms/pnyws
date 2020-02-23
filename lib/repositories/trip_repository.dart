import 'package:pnyws/models/primitives/trip_data.dart';

abstract class TripRepository {
  Stream<TripData> getActiveTrip();

  void setActiveTrip(TripData trip);

  Stream<List<TripData>> getAllTrips();

  void addNewTrip(TripData trip);
}
