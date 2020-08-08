import 'package:pnyws/data/data.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

abstract class TripRepository {
  Stream<TripData> getActiveTrip();

  void setActiveTrip(TripData trip);

  Stream<List<TripData>> getAllTrips();

  Stream<Pair<List<TripData>, TripData>> getAllTripsWithSelected() {
    return CombineLatestStream<dynamic, Pair<List<TripData>, TripData>>(
      [getAllTrips(), getActiveTrip()],
      (values) => Pair<List<TripData>, TripData>(values[0], values[1]),
    ).asBroadcastStream();
  }

  void addNewTrip(TripData trip);

  void removeTrip(TripData trip);

  void addExpenseToTrip(TripData trip, ExpenseData expense);

  void removeExpenseFromTrip(TripData trip, ExpenseData expense);
}
