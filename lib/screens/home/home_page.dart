import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pnyws/screens/home/graph_view.dart';

const kMaxValue = 350.0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> values;

  @override
  void initState() {
    super.initState();

    values = List.generate(100, (_) => Random().nextDouble() * kMaxValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(height: kMaxValue, child: GraphView(values: values)),
      ),
    );
  }
}
