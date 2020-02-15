import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pnyws/app.dart';
import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/services/session.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group("Smoke test", () {
    NavigatorObserver mockObserver;

    setUpAll(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      const registry = Registry();
      final session = Session(environment: Environment.MOCK);
      final navigatorKey = GlobalKey<NavigatorState>();
      final sharedPrefs = SharedPrefs(MockSharedPreferences());
      registry.initialize(session, navigatorKey, "1.0.0", sharedPrefs);

      await tester.pumpWidget(App(
        navigatorKey: navigatorKey,
        isFirstTime: false,
        navigatorObservers: [mockObserver],
      ));

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
