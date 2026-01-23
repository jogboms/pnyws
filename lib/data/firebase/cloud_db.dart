import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb(this._instance)
    : expenses = ExpensesStore(_instance),
      trips = Store(_instance, 'trips'),
      accounts = Store(_instance, 'accounts');

  final FirebaseFirestore _instance;
  final ExpensesStore expenses;
  final Store trips;
  final Store accounts;

  DocumentReference get settings => _instance.doc('settings/common');

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}

class Store {
  Store(this.store, this.path);

  final FirebaseFirestore store;
  final String path;

  Query fetchAll(String userId) => store.collection(path).where('accountID', isEqualTo: userId);

  DocumentReference fetchOne(String uuid) => store.doc('$path/$uuid');
}

class ExpensesStore extends Store {
  ExpensesStore(FirebaseFirestore store) : super(store, 'expenses');

  Query fetchByTrip(String tripId) => store.collection(path).where('tripID', isEqualTo: tripId);
}
