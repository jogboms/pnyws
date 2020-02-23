import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/screens/dashboard/create_trip_modal.dart';
import 'package:pnyws/screens/dashboard/trip_list_item.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<TripData> values = [];

  @override
  void initState() {
    super.initState();

    values = List.generate(
      20,
      (index) => TripData(
        title: "Lagos $index",
        items: List.generate(
          Random().nextInt(20),
          (index) => ExpenseData(
            title: "Hello $index",
            value: Random().nextDouble() * 350,
            createdAt: DateTime.now().subtract(Duration(days: 120)).add(Duration(days: index * 10)),
          ),
        ),
        createdAt: DateTime.now().subtract(Duration(days: 120)).add(Duration(days: index * 10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: kHeroTag,
        child: Icon(Icons.add),
        onPressed: () async {
          final value = await showGeneralDialog<TripData>(
            context: context,
            transitionDuration: Duration(milliseconds: 350),
            barrierLabel: "details",
            barrierColor: MkColors.primaryAccent.withOpacity(.75),
            barrierDismissible: true,
            pageBuilder: (_a, _b, _c) => CreateTripModal(),
          );

          if (value != null) {
            values = [...values, value];
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text("Trips"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close, color: kTextBaseColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 84),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => TripListItem(item: values[values.length - 1 - index]),
                childCount: values.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
