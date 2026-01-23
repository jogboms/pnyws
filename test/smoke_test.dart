import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pnyws/app.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/registry.dart';
import 'package:pnyws/screens/splash/splash_page.dart';
import 'package:pnyws/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Smoke test', () {
    late NavigatorObserver mockObserver;

    setUpAll(() {
      mockObserver = _MockNavigatorObserver();
      registerFallbackValue(MaterialPageRoute<dynamic>(builder: (context) => const SizedBox()));
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      final completer = Completer<Map<String, int>>();

      final authRepository = _MockAuthRepository();
      final tripRepository = _MockTripRepository();

      when(authRepository.signOut).thenAnswer((_) async {});
      when(() => authRepository.onAuthStateChanged).thenAnswer((_) => .value('1'));
      when(tripRepository.getActiveTrip).thenAnswer((_) => .value(TripData(title: 'Test Trip')).asBroadcastStream());

      const registry = Registry();
      final session = Session(environment: .mock);
      final navigatorKey = GlobalKey<NavigatorState>();
      final sharedPrefs = SharedPrefs(_MockSharedPreferences());
      final repository = Repository(auth: authRepository, trip: tripRepository);
      registry.initialize(repository, session, navigatorKey, '1.0.0', sharedPrefs);

      await tester.pumpWidget(App(navigatorKey: navigatorKey, isFirstTime: false, navigatorObservers: [mockObserver]));

      verify(() => mockObserver.didPush(any(), any()));

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      completer.complete({'id': 1});

      await tester.pump();

      verify(() => mockObserver.didPush(any(), any()));
    });
  });
}

class _MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTripRepository extends Mock implements TripRepository {}
