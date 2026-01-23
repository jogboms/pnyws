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
    _account = stateMachine.stream.map((state) => state.account).whereNotNull().shareValue();
    _account
        .switchMap(
          (account) => CombineLatestStream.combine2(
            firebase.db.trips.fetchAll(account.uuid).snapshots().distinct(),
            firebase.db.expenses.fetchAll(account.uuid).snapshots().distinct(),
            (trips, expenses) => _memoizedTripsFn(
              trips.docs,
              _memoizedExpensesFn(expenses.docs),
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

  late final ValueStream<AccountData> _account;

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
  void addNewTrip(TripData trip) async {
    if (_account.valueOrNull case final account?) {
      final data = trip.toMap()..addAll({TripDataKeys.accountId: account.uuid});
      await firebase.db.trips.fetchOne(trip.uuid).set(data);
      setActiveTrip(trip);
    }
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) async {
    if (_account.valueOrNull case final account?) {
      final data = expense.toMap()..addAll({TripDataKeys.tripId: trip.uuid, TripDataKeys.accountId: account.uuid});
      await firebase.db.expenses.fetchOne(expense.uuid).set(data);
    }
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) async {
    if (_account.valueOrNull != null) {
      await firebase.db.expenses.fetchOne(expense.uuid).delete();
    }
  }

  @override
  void removeTrip(TripData trip) async {
    if (_account.valueOrNull != null) {
      await firebase.db.trips.fetchOne(trip.uuid).delete();
      final snapshot = await firebase.db.expenses.fetchByTrip(trip.uuid).get();

      for (final DocumentSnapshot ds in snapshot.docs) {
        await ds.reference.delete();
      }
    }
    _resetPersistedUuid();
  }

  void _persistActiveUuid(String uuid) => pref.setString(_activeItemKey, uuid);

  String _retrievePersistedUuid() => pref.getString(_activeItemKey);

  void _resetPersistedUuid() => pref.remove(_activeItemKey);
}

final _memoizedExpensesFn = memo1<List<DocumentSnapshot>, Map<String, List<ExpenseData>>>(
  (documents) => groupBy<DocumentSnapshot, ExpenseData>(
    documents,
    (item) => item.get(TripDataKeys.tripId) as String,
    (item) => .fromMap(FireSnapshot(item)),
  ),
);

final _memoizedTripsFn = memo2<List<DocumentSnapshot>, Map<String, List<ExpenseData>>, List<TripData>>(
  (documents, expensesMap) =>
      documents.map((item) => TripData.fromMap(FireSnapshot(item), expensesMap)).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
);
