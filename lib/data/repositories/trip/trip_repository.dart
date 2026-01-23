import 'package:pnyws/data/data.dart';
import 'package:rxdart/rxdart.dart';

abstract class TripRepository {
  Stream<TripData?> getActiveTrip();

  void setActiveTrip(TripData trip);

  Stream<List<TripData>> getAllTrips();

  Stream<(List<TripData>, TripData?)> getAllTripsWithSelected() => CombineLatestStream.combine2(
    getAllTrips(),
    getActiveTrip(),
    (trips, selected) => (trips, selected),
  ).asBroadcastStream();

  void addNewTrip(TripData trip);

  void removeTrip(TripData trip);

  void addExpenseToTrip(TripData trip, ExpenseData expense);

  void removeExpenseFromTrip(TripData trip, ExpenseData expense);
}
