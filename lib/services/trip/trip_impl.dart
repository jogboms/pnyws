import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:memoize/memoize.dart';
import 'package:pnyws/firebase/firebase.dart';
import 'package:pnyws/firebase/models.dart';
import 'package:pnyws/models/primitives/account_data.dart';
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

Map<String, List<T>> groupBy<T>(List<dynamic> list, String Function(dynamic) fn, T Function(dynamic) mapper) {
  return list.fold(<String, List<T>>{}, (rv, dynamic x) {
    final key = fn(x);
    (rv[key] = rv[key] ?? <T>[]).add(mapper(x));
    return rv;
  });
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

final memoizedExpensesFn = memo1<List<DocumentSnapshot>, Map<String, List<ExpenseData>>>(
  (documents) => groupBy<ExpenseData>(
    documents,
    (dynamic item) => item["tripID"],
    (dynamic item) {
      final s = FireSnapshot(item);
      final json = s.data;
      return ExpenseData(
        uuid: json["uuid"],
        title: json["title"],
        value: json["value"] ?? 0.0,
        tripID: json["tripID"],
        description: json["description"],
        accountID: json["accountID"],
        createdAt: parseDateTime(json["createdAt"]),
      );
    },
  ),
);

final memoizedTripsFn = memo2<List<DocumentSnapshot>, Map<String, List<ExpenseData>>, List<TripData>>(
  (documents, expensesMap) => documents.map((item) {
    final s = FireSnapshot(item);
    final json = s.data;
    return TripData(
      uuid: json["uuid"],
      title: json["title"],
      description: json["description"],
      accountID: json["accountID"],
      createdAt: parseDateTime(json["createdAt"]),
      items: expensesMap[json["uuid"]] ?? [],
    );
  }).toList(),
);

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
          final trips = memoizedTripsFn(
            _tripsSnapshot.documents,
            memoizedExpensesFn(_expensesSnapshot.documents),
          );

          _tripsController.add(trips);

          if (_activeTripController.value == null) {
            final activeItemId = retrievePersistedUuid();
            _activeTripController.add(
              activeItemId.isNotEmpty ? activeItemId : (trips.isNotEmpty ? trips.last.uuid : null),
            );
            resetPersistedUuid();
          }
        },
      );
    }).listen((_) {});
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
