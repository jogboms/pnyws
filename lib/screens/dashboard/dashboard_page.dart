import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/dashboard/create_trip_modal.dart';
import 'package:pnyws/screens/dashboard/trip_list_item.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.selectedTrip});

  final TripData? selectedTrip;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final Stream<(List<TripData>, TripData?)> _stream;

  @override
  void initState() {
    super.initState();

    _stream = Registry.di().repository.trip.getAllTripsWithSelected();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton(
      heroTag: kHeroTag,
      child: const Icon(Icons.add),
      onPressed: () async {
        final value = await showGeneralDialog<TripData>(
          context: context,
          transitionDuration: const Duration(milliseconds: 350),
          barrierLabel: 'details',
          barrierColor: MkColors.primaryAccent.withValues(alpha: .75),
          barrierDismissible: true,
          pageBuilder: (a, b, c) => const CreateTripModal(),
        );

        if (value != null) {
          Registry.di().repository.trip.addNewTrip(value);
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
    ),
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Trips', style: ThemeProvider.of(context).appBarTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: kTextBaseColor),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.connectionState == .waiting || data == null) {
              return const SliverFillRemaining(child: Center(child: Text('Hang on...')));
            }

            final (values, selectedTrip) = data;
            if (values.isEmpty) {
              return const SliverFillRemaining(child: Center(child: Text('Create a Trip.')));
            }

            return SliverPadding(
              padding: const .only(bottom: 84),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((_, index) {
                  final item = values[values.length - 1 - index];
                  return TripListItem(item: item, isActive: selectedTrip == item);
                }, childCount: values.length),
              ),
            );
          },
        ),
      ],
    ),
  );
}
