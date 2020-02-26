import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/account.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/repositories/trip_repository.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:pnyws/state/state_machine.dart';
import 'package:rxdart/rxdart.dart';

DateTime parseDateTime(String serialized) {
  try {
    return DateTime.tryParse(serialized);
  } catch (e) {
    return DateTime.now();
  }
}

extension ListX<E> on List<E> {
  List<E> tryWhere(bool test(E element)) {
    try {
      return where(test).toList();
    } catch (e) {
      return [];
    }
  }
}

class TripImpl extends TripRepository {
  TripImpl({
    @required this.firebase,
    @required this.stateMachine,
    @required SharedPrefs pref,
  }) : super(pref: pref) {
    account.switchMap((_account) {
      return CombineLatestStream.combine2<QuerySnapshot, QuerySnapshot, void>(
        firebase.db.trips(_account.uuid).snapshots(),
        firebase.db.expenses(_account.uuid).snapshots(),
        (_tripsSnapshot, _expensesSnapshot) async {
          final expenses = _expensesSnapshot.documents.map((item) {
            final s = FireSnapshot(item);
            final json = s.data;
            return ExpenseData(
              id: json["uuid"],
              title: json["title"],
              value: json["value"] ?? 0.0,
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
              items: expenses.tryWhere((exp) => exp.tripID == json["uuid"]),
            );
          }).toList();

          _tripsController.add(trips);

          if (_activeTripController.value == null) {
            final activeItemId = retrievePersistedUuid() ?? "";
            _activeTripController
                .add(activeItemId.isNotEmpty ? activeItemId : (trips.isNotEmpty ? trips.last.id : null));
            removePersistedUuid();
          }
        },
      );
    }).listen((_) {});
  }

  final Firebase firebase;
  final StateMachine stateMachine;

  final _activeTripController = BehaviorSubject<String>();
  final _tripsController = BehaviorSubject<List<TripData>>();

  Stream<AccountModel> get account =>
      stateMachine.stream.where((state) => state.account != null).map((state) => state.account);

  @override
  Stream<TripData> getActiveTrip() {
    return CombineLatestStream.combine2<String, List<TripData>, TripData>(
      _activeTripController.stream.where((id) => id != null),
      getAllTrips(),
      (id, list) => list.firstWhere((item) => item.id == id),
    ).asBroadcastStream();
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
    StreamSubscription<AccountModel> sub;
    sub = account.listen((_account) {
      final data = trip.toMap()
        ..addAll(<String, dynamic>{
          "accountID": _account.uuid,
        });
      firebase.db.trips(_account.uuid).reference().document(trip.id).setData(data).then((r) {
        setActiveTrip(trip);
        sub.cancel();
      });
    });
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountModel> sub;
    sub = account.listen((_account) {
      final data = expense.toMap()
        ..addAll(<String, dynamic>{
          "tripID": trip.id,
          "accountID": _account.uuid,
        });
      firebase.db.expenses(_account.uuid).reference().document(expense.id).setData(data).then((r) {
        sub.cancel();
      });
    });
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountModel> sub;
    sub = account.listen((_account) {
      firebase.db.expenses(_account.uuid).reference().document(expense.id).delete().then((r) {
        sub.cancel();
      });
    });
  }

  @override
  void removeTrip(TripData trip) {
    StreamSubscription<AccountModel> sub;
    sub = account.listen((_account) {
      firebase.db.trips(_account.uuid).reference().document(trip.id).delete().then((r) {
        firebase.db.expenses(_account.uuid).where('tripID', isEqualTo: trip.id).getDocuments().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.documents) {
            ds.reference.delete();
          }
          sub.cancel();
        });
      });
    });
  }
}
