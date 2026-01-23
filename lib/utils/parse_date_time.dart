DateTime? parseDateTime(String serialized) {
  try {
    return .tryParse(serialized);
  } catch (e) {
    return .now();
  }
}
