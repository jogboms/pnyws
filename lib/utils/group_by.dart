Map<String, List<T>> groupBy<U, T>(List<U> list, String Function(U) fn, T Function(U) mapper) {
  return list.fold(<String, List<T>>{}, (rv, U x) {
    final key = fn(x);
    (rv[key] = rv[key] ?? <T>[]).add(mapper(x));
    return rv;
  });
}
