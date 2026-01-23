import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/home/create_expense_modal.dart';
import 'package:pnyws/screens/home/graph_view.dart';
import 'package:pnyws/screens/home/sliver_expense_list.dart';
import 'package:pnyws/utils/utils.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Stream<TripData?> _stream;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..forward();

    _stream = Registry.di().repository.trip.getActiveTrip();
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
      floatingActionButton: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const SizedBox();
          }

          return FloatingActionButton(
            heroTag: kHeroTag,
            child: const Icon(Icons.add),
            onPressed: () async {
              final value = await showGeneralDialog<ExpenseData>(
                context: context,
                transitionDuration: const Duration(milliseconds: 350),
                barrierLabel: 'details',
                barrierColor: MkColors.primaryAccent.withValues(alpha: .75),
                barrierDismissible: true,
                pageBuilder: (a, b, c) => const CreateExpenseModal(),
              );

              if (value != null) {
                Registry.di().repository.trip.addExpenseToTrip(data, value);
              }
            },
          );
        },
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const Center(child: Text('Hang on...'));
          }

          final data = snapshot.data;
          if (data == null) {
            return Stack(
              children: [
                const Center(child: Text('Select a Trip.')),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    child: const Icon(Icons.dashboard),
                    onPressed: () => Registry.di().sharedCoordinator.toDashboard(),
                  ),
                ),
              ],
            );
          }

          final trip = data;
          final createdAt = trip.createdAt;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: Column(
                  children: [
                    Text(trip.title, style: theme.appBarTitle),
                    Text(
                      '${createdAt.day}.${createdAt.month}.${createdAt.year.toString().substring(2)}',
                      style: theme.body3.copyWith(
                        letterSpacing: 0.125,
                        color: kTextBaseColor.withValues(alpha: .75),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.dashboard, color: kTextBaseColor),
                    onPressed: () => Registry.di().sharedCoordinator.toDashboard(selectedTrip: trip),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const ScaledBox.vertical(16),
                    Text(
                      'TOTAL AMOUNT',
                      style: theme.xxsmallSemi.copyWith(color: kTextBaseColor.withValues(alpha: .5)),
                      textAlign: .center,
                    ),
                    const ScaledBox.vertical(12),
                    Text(
                      Money(trip.items.fold<double>(0, (p, c) => p + c.value)).formatted,
                      style: theme.headline.copyWith(letterSpacing: 1.5),
                      textAlign: .center,
                    ),
                    if (trip.items.isNotEmpty) ...[
                      const ScaledBox.vertical(32),
                      SizedBox(
                        height: context.scaleY(240),
                        child: GraphView(
                          key: PageStorageKey<Type>(runtimeType),
                          animation: _controller,
                          values: trip.items,
                        ),
                      ),
                    ],
                    const ScaledBox.vertical(24),
                    Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: theme.xxsmallSemi.copyWith(color: kTextBaseColor.withValues(alpha: .5)),
                      textAlign: .center,
                    ),
                    const ScaledBox.vertical(24),
                    Container(
                      color: MkColors.primaryAccent.shade800.withValues(alpha: .5),
                      padding: const .symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            '${trip.items.length} EXPENSES',
                            style: theme.xxsmallSemi.copyWith(
                              color: kTextBaseColor.withValues(alpha: .5),
                              letterSpacing: 1.15,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: kTextBaseColor.withValues(alpha: .5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const .only(bottom: 84),
                sliver: SliverExpenseList(trip: trip),
              ),
            ],
          );
        },
      ),
    );
  }
}
