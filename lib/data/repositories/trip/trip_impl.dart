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
    @required SharedPrefs pref,
  }) : super(pref: pref) {
    account.switchMap((_account) {
      return CombineLatestStream<QuerySnapshot, List<TripData>>(
        [
          firebase.db.trips(_account.uuid).snapshots().distinct(),
          firebase.db.expenses(_account.uuid).snapshots().distinct(),
        ],
        (values) => memoizedTripsFn(
          values[0].documents,
          memoizedExpensesFn(values[1].documents),
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
    sub = account.listen((_account) {
      final data = trip.toMap()
        ..addAll(<String, dynamic>{
          "accountID": _account.uuid,
        });
      firebase.db.trips(_account.uuid).reference().document(trip.uuid).setData(data).then((r) {
        setActiveTrip(trip);
        sub.cancel();
      });
    });
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) {
      final data = expense.toMap()
        ..addAll(<String, dynamic>{
          "tripID": trip.uuid,
          "accountID": _account.uuid,
        });
      firebase.db.expenses(_account.uuid).reference().document(expense.uuid).setData(data).then((r) {
        sub.cancel();
      });
    });
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) {
      firebase.db.expenses(_account.uuid).reference().document(expense.uuid).delete().then((r) {
        sub.cancel();
      });
    });
  }

  @override
  void removeTrip(TripData trip) {
    StreamSubscription<AccountData> sub;
    sub = account.listen((_account) {
      firebase.db.trips(_account.uuid).reference().document(trip.uuid).delete().then((r) {
        firebase.db.expenses(_account.uuid).where('tripID', isEqualTo: trip.uuid).getDocuments().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.documents) {
            ds.reference.delete();
          }
          sub.cancel();
        });
      });
    });
  }
}
