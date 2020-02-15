import 'package:flutter/material.dart';
import 'package:pnyws/registry.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<Map<String, int>> _future;

  @override
  void initState() {
    super.initState();

    _future = Registry.di().repository.auth.getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, int>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) async {
                Registry.di().sharedCoordinator.toHome();
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
