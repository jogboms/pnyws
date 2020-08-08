DateTime parseDateTime(String serialized) {
  try {
    return DateTime.tryParse(serialized);
  } catch (e) {
    return DateTime.now();
  }
}
