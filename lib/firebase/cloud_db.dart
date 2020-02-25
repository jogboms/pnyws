import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDb {
  CloudDb(this._instance);

  final Firestore _instance;

  DocumentReference account(String uuid) => _instance.document('accounts/$uuid');

  DocumentReference get settings => _instance.document('settings/common');

  Query trips(String userId) => _instance.collection('trips').where('accountID', isEqualTo: userId);

  Query expenses(String userId) => _instance.collection('expenses').where('accountID', isEqualTo: userId);

  Future<void> batchAction(void Function(WriteBatch batch) action) {
    final WriteBatch batch = _instance.batch();

    action(batch);

    return batch.commit();
  }
}
