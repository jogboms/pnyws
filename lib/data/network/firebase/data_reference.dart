abstract class DataReference<T> {
  DataReference();

  T get source;

  Future<void> delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false});

  Future<void> updateData(Map<String, dynamic> data);
}
