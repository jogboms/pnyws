import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/repositories/trip_repository.dart';

class TripImpl implements TripRepository {
  @override
  Stream<TripData> getActiveTrip() {
    throw UnimplementedError();
  }

  @override
  Stream<List<TripData>> getAllTrips() {
    throw UnimplementedError();
  }

  @override
  void setActiveTrip(TripData trip) {
    throw UnimplementedError();
  }

  @override
  void addNewTrip(TripData trip) {
    throw UnimplementedError();
  }

  @override
  void addExpenseToTrip(TripData trip, ExpenseData expense) {
    throw UnimplementedError();
  }

  @override
  void removeExpenseFromTrip(TripData trip, ExpenseData expense) {
    throw UnimplementedError();
  }

  @override
  void removeTrip(TripData trip) {
    throw UnimplementedError();
  }
}
