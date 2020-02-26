import 'package:flutter/foundation.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/services/shared_prefs.dart';

const ACTIVE_ITEM_KEY = "ACTIVE_ITEM_KEY";

abstract class TripRepository {
  TripRepository({@required this.pref});

  final SharedPrefs pref;

  Stream<TripData> getActiveTrip();

  void setActiveTrip(TripData trip);

  Stream<List<TripData>> getAllTrips();

  void addNewTrip(TripData trip);

  void removeTrip(TripData trip);

  void addExpenseToTrip(TripData trip, ExpenseData expense);

  void removeExpenseFromTrip(TripData trip, ExpenseData expense);
}

extension TripRepositoryX on TripRepository {
  void persistActiveUuid(String uuid) {
    if (uuid == null) {
      pref.remove(ACTIVE_ITEM_KEY);
    } else {
      pref.setString(ACTIVE_ITEM_KEY, uuid);
    }
  }

  String retrievePersistedUuid() {
    return pref.getString(ACTIVE_ITEM_KEY);
  }

  void removePersistedUuid() {
    pref.remove(ACTIVE_ITEM_KEY);
  }

  List<TripData> modifyTripFromList(List<TripData> trips, TripData trip) {
    return [...removeTripFromList(trips, trip), trip];
  }

  List<TripData> removeTripFromList(List<TripData> trips, TripData trip) {
    return trips.where((_trip) => _trip.id != trip.id).toList();
  }
}
