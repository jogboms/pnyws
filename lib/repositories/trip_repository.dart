import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';

abstract class TripRepository {
  Stream<TripData> getActiveTrip();

  void setActiveTrip(TripData trip);

  Stream<List<TripData>> getAllTrips();

  void addNewTrip(TripData trip);

  void removeTrip(TripData trip);

  void addExpenseToTrip(TripData trip, ExpenseData expense);

  void removeExpenseFromTrip(TripData trip, ExpenseData expense);
}

extension TripRepositoryX on TripRepository {
  List<TripData> modifyTripFromList(List<TripData> trips, TripData trip) {
    return [...removeTripFromList(trips, trip), trip];
  }

  List<TripData> removeTripFromList(List<TripData> trips, TripData trip) {
    return trips.where((_trip) => _trip.id != trip.id).toList();
  }
}
