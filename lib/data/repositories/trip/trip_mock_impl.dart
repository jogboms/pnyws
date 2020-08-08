import 'dart:async';

import 'package:pnyws/data/data.dart';
import 'package:rxdart/rxdart.dart';

import './trip_repository.dart';

class TripMockImpl extends TripRepository {
  TripMockImpl({List<TripData> trips}) {
    _tripsController.add(trips ?? []);

    _activeTripController.add(trips.last);
  }

  final _activeTripController = BehaviorSubject<TripData>();
  final _tripsController = BehaviorSubject<List<TripData>>();

  @override
  Stream<TripData> getActiveTrip() => _activeTripController.stream;

  @override
  Stream<List<TripData>> getAllTrips() => _tripsController.stream;

  @override
  void setActiveTrip(TripData trip) {
    _activeTripController.add(trip);
  }

  @override
  void addNewTrip(TripData trip) {
    _tripsController.add([..._tripsController.value, trip]);
    setActiveTrip(trip);
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    final newTrip = trip.copyWith(items: [...trip.items, expense]);
    _tripsController.add(modifyTripFromList(_tripsController.value, newTrip));
    _activeTripController.add(newTrip);
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    final newTrip = trip.copyWith(
      items: trip.items.where((_expense) => _expense.uuid != expense.uuid).toList(),
    );
    _tripsController.add(modifyTripFromList(_tripsController.value, newTrip));
    _activeTripController.add(newTrip);
  }

  @override
  void removeTrip(TripData trip) {
    _tripsController.add(removeTripFromList(_tripsController.value, trip));
    if (_activeTripController.value == trip) {
      setActiveTrip(null);
    }
  }

  List<TripData> modifyTripFromList(List<TripData> trips, TripData trip) {
    return [...removeTripFromList(trips, trip), trip];
  }

  List<TripData> removeTripFromList(List<TripData> trips, TripData trip) {
    return trips.where((_trip) => _trip.uuid != trip.uuid).toList();
  }
}
