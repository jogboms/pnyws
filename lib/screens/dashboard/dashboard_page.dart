import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/dashboard/create_trip_modal.dart';
import 'package:pnyws/screens/dashboard/trip_list_item.dart';
import 'package:pnyws/utils/pair.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key, this.selectedTrip}) : super(key: key);

  final TripData selectedTrip;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Stream<Pair<List<TripData>, TripData>> stream;

  @override
  void initState() {
    super.initState();

    stream = Registry.di().repository.trip.getAllTripsWithSelected();
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
            Registry.di().repository.trip.addNewTrip(value);
            Navigator.pop(context);
          }
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Trips", style: ThemeProvider.of(context).appBarTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close, color: kTextBaseColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          StreamBuilder<Pair<List<TripData>, TripData>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return SliverFillRemaining(
                  child: Center(child: Text("Hang on...")),
                );
              }

              if (snapshot.hasData && (snapshot.data == null || snapshot.data.first.isEmpty)) {
                return SliverFillRemaining(
                  child: Center(child: Text("Create a Trip.")),
                );
              }

              final values = snapshot.data.first;
              final selectedTrip = snapshot.data.second;

              return SliverPadding(
                padding: EdgeInsets.only(bottom: 84),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      final item = values[values.length - 1 - index];
                      return TripListItem(item: item, isActive: selectedTrip == item);
                    },
                    childCount: values.length,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
