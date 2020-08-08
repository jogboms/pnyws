import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb(this._instance)
      : expenses = _ExpensesStore(_instance),
        trips = _Store(_instance, "trips"),
        accounts = _Store(_instance, "accounts");

  final FirebaseFirestore _instance;
  final _ExpensesStore expenses;
  final _Store trips;
  final _Store accounts;

  DocumentReference get settings => _instance.doc('settings/common');

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}

class _Store {
  _Store(this.store, this.path);

  final FirebaseFirestore store;
  final String path;

  Query fetchAll(String userId) => store.collection(path).where('accountID', isEqualTo: userId);

  DocumentReference fetchOne(String uuid) => store.doc('$path/$uuid');
}

class _ExpensesStore extends _Store {
  _ExpensesStore(FirebaseFirestore store) : super(store, "expenses");

  Query fetchByTrip(String tripId) => store.collection(path).where('tripID', isEqualTo: tripId);
}
