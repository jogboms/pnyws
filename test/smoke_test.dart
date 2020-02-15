import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pnyws/app.dart';
import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/repositories/auth_repository.dart';
import 'package:pnyws/repositories/repository.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/services/session.dart';
import 'package:pnyws/services/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group("Smoke test", () {
    NavigatorObserver mockObserver;

    setUpAll(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      final completer = Completer<Map<String, int>>();

      final authRepository = MockAuthRepository();
      when(authRepository.getAccount()).thenAnswer((_) => completer.future);

      const registry = Registry();
      final session = Session(environment: Environment.MOCK);
      final navigatorKey = GlobalKey<NavigatorState>();
      final sharedPrefs = SharedPrefs(MockSharedPreferences());
      final repository = Repository(auth: authRepository);
      registry.initialize(repository, session, navigatorKey, "1.0.0", sharedPrefs);

      await tester.pumpWidget(App(
        navigatorKey: navigatorKey,
        isFirstTime: false,
        navigatorObservers: [mockObserver],
      ));

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      completer.complete({"id": 1});

      await tester.pump();

      verify(mockObserver.didPush(any, any));
    });
  });
}
