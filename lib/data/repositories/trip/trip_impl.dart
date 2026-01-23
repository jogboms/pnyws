import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' hide groupBy;
import 'package:memoize/memoize.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:pnyws/state/state_machine.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

const _activeItemKey = 'ACTIVE_ITEM_KEY';

class TripImpl extends TripRepository {
  TripImpl({
    required this.firebase,
    required this.stateMachine,
    required this.pref,
  }) {
    account
        .switchMap(
          (account) => CombineLatestStream<QuerySnapshot, List<TripData>>(
            [
              firebase.db.trips.fetchAll(account.uuid).snapshots().distinct(),
              firebase.db.expenses.fetchAll(account.uuid).snapshots().distinct(),
            ],
            (values) => _memoizedTripsFn(
              values[0].docs,
              _memoizedExpensesFn(values[1].docs),
            )..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
          ).distinct(),
        )
        .listen(_tripsController.add);
  }

  final Firebase firebase;
  final StateMachine stateMachine;
  final SharedPrefs pref;

  final _activeTripController = BehaviorSubject<String>();
  final _tripsController = BehaviorSubject<List<TripData>>();

  Stream<AccountData> get account => stateMachine.stream.map((state) => state.account).whereNotNull();

  @override
  Stream<TripData?> getActiveTrip() => CombineLatestStream.combine2(
    _activeTripController.stream.startWith(_retrievePersistedUuid()),
    getAllTrips(),
    (id, list) => list.firstWhereOrNull((item) => item.uuid == id),
  ).asBroadcastStream();

  @override
  Stream<List<TripData>> getAllTrips() => _tripsController.stream;

  @override
  void setActiveTrip(TripData trip) {
    _persistActiveUuid(trip.uuid);
    _activeTripController.add(trip.uuid);
  }

  @override
  void addNewTrip(TripData trip) {
    StreamSubscription<AccountData>? sub;
    sub = account.listen((account) async {
      final data = trip.toMap()..addAll(<String, String>{'accountID': account.uuid});

      await firebase.db.trips.fetchOne(trip.uuid).set(data);
      setActiveTrip(trip);
      await sub?.cancel();
    });
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData>? sub;
    sub = account.listen((account) async {
      final data = expense.toMap()..addAll(<String, String>{'tripID': trip.uuid, 'accountID': account.uuid});
      await firebase.db.expenses.fetchOne(expense.uuid).set(data);
      await sub?.cancel();
    });
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    StreamSubscription<AccountData>? sub;
    sub = account.listen((account) async {
      await firebase.db.expenses.fetchOne(expense.uuid).delete();
      await sub?.cancel();
    });
  }

  @override
  void removeTrip(TripData trip) {
    StreamSubscription<AccountData>? sub;
    sub = account.listen((account) async {
      await firebase.db.trips.fetchOne(trip.uuid).delete();
      final snapshot = await firebase.db.expenses.fetchByTrip(trip.uuid).get();

      for (final DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
      await sub?.cancel();
    });
    _resetPersistedUuid();
  }

  void _persistActiveUuid(String uuid) => pref.setString(_activeItemKey, uuid);

  String _retrievePersistedUuid() => pref.getString(_activeItemKey);

  void _resetPersistedUuid() => pref.remove(_activeItemKey);
}

final _memoizedExpensesFn = memo1<List<DocumentSnapshot>, Map<String, List<ExpenseData>>>(
  (documents) => groupBy<DocumentSnapshot, ExpenseData>(
    documents,
    (item) => item.get('tripID') as String,
    (item) => ExpenseData.fromMap(FireSnapshot(item).data),
  ),
);

final _memoizedTripsFn = memo2<List<DocumentSnapshot>, Map<String, List<ExpenseData>>, List<TripData>>(
  (documents, expensesMap) =>
      documents.map((item) => TripData.fromMap(FireSnapshot(item).data, expensesMap)).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
);
