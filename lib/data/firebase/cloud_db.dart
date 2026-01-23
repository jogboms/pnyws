import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pnyws/data/entities/trip_data.dart';

class CloudDb {
  CloudDb(FirebaseFirestore instance)
    : expenses = ExpensesStore(instance),
      trips = Store(instance, CloudDbTables.trips),
      accounts = Store(instance, CloudDbTables.accounts);

  final ExpensesStore expenses;
  final Store trips;
  final Store accounts;
}

class Store {
  Store(this.store, this.path);

  @protected
  final FirebaseFirestore store;
  @protected
  final String path;

  Query fetchAll(String userId) => store.collection(path).where(TripDataKeys.accountId, isEqualTo: userId);

  DocumentReference fetchOne(String uuid) => store.doc('$path/$uuid');
}

class ExpensesStore extends Store {
  ExpensesStore(FirebaseFirestore store) : super(store, CloudDbTables.expenses);

  Query fetchByTrip(String tripId) => store.collection(path).where(TripDataKeys.tripId, isEqualTo: tripId);
}

final class CloudDbTables {
  static const trips = 'trips';
  static const accounts = 'accounts';
  static const expenses = 'expenses';
}
