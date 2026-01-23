import 'package:flutter/material.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/home/expense_list_item.dart';

class SliverExpenseList extends StatelessWidget {
  const SliverExpenseList({super.key, required this.trip});

  final TripData trip;

  @override
  Widget build(BuildContext context) {
    if (trip.items.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text('No Expenses Added.')));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => ExpenseListItem(
          item: trip.items[trip.items.length - 1 - index],
          onDeleteAction: (expense) {
            Registry.di().repository.trip.removeExpenseFromTrip(trip, expense);
          },
        ),
        childCount: trip.items.length,
      ),
    );
  }
}
