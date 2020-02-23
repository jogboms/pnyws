import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/models/primitives/expense_data.dart';
import 'package:pnyws/models/primitives/trip_data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/home/create_expense_modal.dart';
import 'package:pnyws/screens/home/expense_list_item.dart';
import 'package:pnyws/screens/home/graph_view.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Stream<TripData> stream;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..forward();

    stream = Registry.di().repository.trip.getActiveTrip();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: kHeroTag,
        child: Icon(Icons.add),
        onPressed: () async {
          final value = await showGeneralDialog<ExpenseData>(
            context: context,
            transitionDuration: Duration(milliseconds: 350),
            barrierLabel: "details",
            barrierColor: MkColors.primaryAccent.withOpacity(.75),
            barrierDismissible: true,
            pageBuilder: (_a, _b, _c) => CreateExpenseModal(),
          );

          if (value != null) {
            // TODO
//            values = [...values, value];
          }
        },
      ),
      body: StreamBuilder<TripData>(
        stream: stream,
        builder: (context, AsyncSnapshot<TripData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading..."));
          }

          if (snapshot.data == null) {
            return Center(child: Text("No Trips Yet"));
          }

          final trip = snapshot.data;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: Text(trip.title),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.dashboard, color: kTextBaseColor),
                    onPressed: () => Registry.di().sharedCoordinator.toDashboard(),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const ScaledBox.vertical(8),
                    Text(
                      "TOTAL AMOUNT",
                      style: theme.xxsmallSemi.copyWith(color: kTextBaseColor.withOpacity(.5)),
                      textAlign: TextAlign.center,
                    ),
                    const ScaledBox.vertical(12),
                    Text(
                      "\$${trip.items.fold<double>(0, (p, c) => p + c.value).toStringAsFixed(2)}",
                      style: theme.headline.copyWith(letterSpacing: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const ScaledBox.vertical(32),
                    SizedBox(
                      height: context.scaleY(240),
                      child: GraphView(
                        key: PageStorageKey<Type>(runtimeType),
                        animation: _controller,
                        values: trip.items,
                      ),
                    ),
                    const ScaledBox.vertical(24),
                    Text(
                      "${DateFormat.yMMMMEEEEd().format(DateTime.now())}",
                      style: theme.xxsmallSemi.copyWith(color: kTextBaseColor.withOpacity(.5)),
                      textAlign: TextAlign.center,
                    ),
                    const ScaledBox.vertical(24),
                    Container(
                      color: MkColors.primaryAccent.shade800.withOpacity(.5),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${trip.items.length} EXPENSES",
                            style:
                                theme.xxsmallSemi.copyWith(color: kTextBaseColor.withOpacity(.5), letterSpacing: 1.15),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: kTextBaseColor.withOpacity(.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 84),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ExpenseListItem(item: trip.items[trip.items.length - 1 - index]),
                    childCount: trip.items.length,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
