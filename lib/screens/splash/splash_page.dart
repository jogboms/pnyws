import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_strings.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final Stream<String> _stream;

  @override
  void initState() {
    super.initState();

    _stream = Registry.di().repository.auth.onAuthStateChanged;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: _stream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) async => Registry.di().sharedCoordinator.toHome());
        }

        return const _Content(isColdStart: true);
      },
    ),
  );
}

class _Content extends StatefulWidget {
  const _Content({required this.isColdStart});

  final bool isColdStart;

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isColdStart;
    if (widget.isColdStart) {
      _onLogin();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        top: null,
        bottom: 124.0,
        child: Builder(
          builder: (_) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: _onLogin,
                child: Text('Continue with Google', style: ThemeProvider.of(context).bodyBold),
              ),
            );
          },
        ),
      ),
    ],
  );

  void _onLogin() async {
    try {
      setState(() => _isLoading = true);
      // TODO(jogboms): move this out of here
      await Registry.di().repository.auth.signIn();
    } catch (e) {
      // TODO(jogboms): move this out of here
      final message = MkStrings.genericError(e);

      if (message.isNotEmpty) {
        print(message);
        //        SnackBarProvider.of(context).show(message, duration: const Duration(milliseconds: 3500));
      }

      // TODO(jogboms): move this out of here
      await Registry.di().repository.auth.signOut();

      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);

      print(e);
      //      SnackBarProvider.of(context).show(e.toString());
    }
  }
}
