import 'package:pnyws/data/data.dart';
import 'package:pnyws/utils/pair.dart';
import 'package:rxdart/rxdart.dart';

const ACTIVE_ITEM_KEY = "ACTIVE_ITEM_KEY";

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

extension TripRepositoryX on TripRepository {
  void persistActiveUuid(String uuid) {
    if (uuid == null) {
      resetPersistedUuid();
    } else {
      pref.setString(ACTIVE_ITEM_KEY, uuid);
    }
  }

  String retrievePersistedUuid() {
    return pref.getString(ACTIVE_ITEM_KEY) ?? "";
  }

  void resetPersistedUuid() {
    pref.remove(ACTIVE_ITEM_KEY);
  }
}
