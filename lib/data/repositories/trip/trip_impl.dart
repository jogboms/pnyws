import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:memoize/memoize.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:pnyws/state/state_machine.dart';
import 'package:rxdart/rxdart.dart';

import './trip_repository.dart';



const ACTIVE_ITEM_KEY = "ACTIVE_ITEM_KEY";

class TripImpl extends TripRepository {
  TripImpl({
    @required this.firebase,
    @required this.stateMachine,
    @required this.pref,
  }) {
    account.switchMap((_account) {
      return CombineLatestStream<QuerySnapshot, List<TripData>>(
        [
          firebase.db.trips.fetchAll(_account.uuid).snapshots().distinct(),
          firebase.db.expenses.fetchAll(_account.uuid).snapshots().distinct(),
        ],
        (values) => memoizedTripsFn(
          values[0].docs,
          memoizedExpensesFn(values[1].docs),
        )..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      ).distinct();
    }).listen((trips) {
      _tripsController.add(trips);

      if (_activeTripController.value == null) {
        final activeItemId = retrievePersistedUuid();
        _activeTripController.add(
          activeItemId.isNotEmpty ? activeItemId : (trips.isNotEmpty ? trips.last.uuid : null),
        );
      }
    });
  }

  final Firebase firebase;
  final StateMachine stateMachine;
  final SharedPrefs pref;

  final _activeTripController = BehaviorSubject<String>();
  final _tripsController = BehaviorSubject<List<TripData>>();

  Stream<AccountData> get account =>
      stateMachine.stream.where((state) => state.account != null).map((state) => state.account);

  @override
  Stream<TripData> getActiveTrip() {
    return CombineLatestStream.combine2<String, List<TripData>, TripData>(
      _activeTripController.stream.where((id) => id != null),
      getAllTrips(),
      (id, list) => list.firstWhere((item) => item.uuid == id),
    ).asBroadcastStream();
  }

  @override
  Stream<List<TripData>> getAllTrips() => _tripsController.stream;

  @override
  void setActiveTrip(TripData trip) {
    persistActiveUuid(trip?.uuid);
    _activeTripController.add(trip?.uuid);
  }

  @override
  void addNewTrip(TripData trip) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) async {
      final data = trip.toMap()
        ..addAll(<String, dynamic>{
          "accountID": _account.uuid,
        });

      await firebase.db.trips.fetchOne(trip.uuid).set(data);
      setActiveTrip(trip);
      await sub.cancel();
    });
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) async {
      final data = expense.toMap()
        ..addAll(<String, dynamic>{
          "tripID": trip.uuid,
          "accountID": _account.uuid,
        });
      await firebase.db.expenses.fetchOne(expense.uuid).set(data);
      await sub.cancel();
    });
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) async {
      await firebase.db.expenses.fetchOne(expense.uuid).delete();
      await sub.cancel();
    });
  }

  @override
  void removeTrip(TripData trip) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) async {
      await firebase.db.trips.fetchOne(trip.uuid).delete();
      final snapshot = await firebase.db.expenses.fetchByTrip(trip.uuid).get();

      for (DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
      await sub.cancel();
    });
  }
}
