import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';
import 'package:intl/intl.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/screens/home/graph_view.dart';
import 'package:pnyws/widgets/scaled_box.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<double> values;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..forward();

    values = List.generate(100, (_) => Random().nextDouble() * 350);
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
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(),
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
                  "\$${values.fold<double>(0, (p, c) => p + c).toStringAsFixed(2)}",
                  style: theme.headline.copyWith(letterSpacing: 1.5),
                  textAlign: TextAlign.center,
                ),
                const ScaledBox.vertical(32),
                SizedBox(
                  height: context.scaleY(240),
                  child: GraphView(
                    key: PageStorageKey<Type>(runtimeType),
                    animation: _controller,
                    values: values,
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
                        "${values.length} EXPENSES",
                        style: theme.xxsmallSemi.copyWith(letterSpacing: 1.15),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: kTextBaseColor),
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
                (_, index) {
                  final value = values[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: .125),
                    color: MkColors.primaryAccent.shade500.withOpacity(.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Red Suya",
                            style: theme.body1.copyWith(letterSpacing: 0.125),
                          ),
                        ),
                        Text(
                          "\$${value.toStringAsFixed(2)}",
                          style: theme.subhead1Bold.copyWith(letterSpacing: 1.05),
                        ),
                      ],
                    ),
                  );
                },
                childCount: values.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
