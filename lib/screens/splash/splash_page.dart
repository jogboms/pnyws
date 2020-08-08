import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_strings.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Stream<String> _stream;

  @override
  void initState() {
    super.initState();

    _stream = Registry.di().repository.auth.onAuthStateChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) async => Registry.di().sharedCoordinator.toHome(),
            );
          }

          return _Content(isColdStart: true);
        },
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key key, @required this.isColdStart}) : super(key: key);

  final bool isColdStart;

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isColdStart;
    if (widget.isColdStart) {
      _onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: null,
          bottom: 124.0,
          child: Builder(builder: (_) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: RaisedButton(
                color: Colors.white,
                child: Text("Continue with Google", style: ThemeProvider.of(context).bodyBold),
                onPressed: _onLogin,
              ),
            );
          }),
        )
      ],
    );
  }

  void _onLogin() async {
    try {
      setState(() => isLoading = true);
      // TODO: move this out of here
      await Registry.di().repository.auth.signInWithGoogle();
    } catch (e) {
      // TODO: move this out of here
      final message = MkStrings.genericError(e);

      if (message.isNotEmpty) {
        print(message);
//        SnackBarProvider.of(context).show(message, duration: const Duration(milliseconds: 3500));
      }

      // TODO: move this out of here
      await Registry.di().repository.auth.signOut();

      if (!mounted) {
        return;
      }

      setState(() => isLoading = false);

      print(e.toString());
//      SnackBarProvider.of(context).show(e.toString());
    }
  }
}
