import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/repositories/trip_repository.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:pnyws/state/app_state.dart';
import 'package:pnyws/state/state_machine.dart';
import 'package:rxdart/rxdart.dart';

DateTime parseDateTime(String serialized) {
  try {
    return DateTime.tryParse(serialized);
  } catch (e) {
    return DateTime.now();
  }
}

class TripImpl extends TripRepository {
  TripImpl({
    @required this.firebase,
    @required this.stateMachine,
    @required SharedPrefs pref,
  }) : super(pref: pref) {
    stateMachine.stream.where((state) => state.account != null).switchMap((state) {
      final activeItemId = retrievePersistedUuid();
      return CombineLatestStream.combine2<QuerySnapshot, QuerySnapshot, void>(
        firebase.db.trips(state.account.uuid).snapshots(),
        firebase.db.expenses(state.account.uuid).snapshots(),
        (_tripsSnapshot, _expensesSnapshot) {
          final expenses = _expensesSnapshot.documents.map((item) {
            final s = FireSnapshot(item);
            final json = s.data;
            return ExpenseData(
              id: json["uuid"],
              title: json["title"],
              tripID: json["tripID"],
              description: json["description"],
              accountID: json["accountID"],
              createdAt: parseDateTime(json["createdAt"]),
            );
          }).toList();

          final trips = _tripsSnapshot.documents.map((item) {
            final s = FireSnapshot(item);
            final json = s.data;
            return TripData(
              id: json["uuid"],
              title: json["title"],
              description: json["description"],
              accountID: json["accountID"],
              createdAt: parseDateTime(json["createdAt"]),
              items: expenses.takeWhile((exp) => exp.tripID == json["uuid"]).toList(),
            );
          }).toList();

          _tripsController.add(trips);
          _activeTripController.add(activeItemId ?? (trips.isNotEmpty ? trips.last.id : null));
        },
      );
    }).listen((_) {});
  }

  final Firebase firebase;
  final StateMachine stateMachine;

  final _activeTripController = BehaviorSubject<String>();
  final _tripsController = BehaviorSubject<List<TripData>>();

  @override
  Stream<TripData> getActiveTrip() {
    return CombineLatestStream.combine2<String, List<TripData>, TripData>(
        _activeTripController.stream.where((id) => id != null), getAllTrips(), (id, list) {
      return list.firstWhere((item) => item.id == id);
    }).asBroadcastStream();
  }

  @override
  Stream<List<TripData>> getAllTrips() => _tripsController.stream;

  @override
  void setActiveTrip(TripData trip) {
    persistActiveUuid(trip?.id);
    _activeTripController.add(trip?.id);
  }

  @override
  void addNewTrip(TripData trip) {
    StreamSubscription<AppState> sub;
    sub = stateMachine.stream.where((state) => state.account != null).listen((state) {
      final data = trip.toMap()
        ..addAll(<String, dynamic>{
          "accountID": state.account.uuid,
        });
      firebase.db.trips(state.account.uuid).reference().document(trip.id).setData(data).then((r) {
        setActiveTrip(trip);
        sub.cancel();
      });
    });
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    throw UnimplementedError();
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    throw UnimplementedError();
  }

  @override
  void removeTrip(TripData trip) {
    throw UnimplementedError();
  }
}
