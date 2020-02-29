import 'package:pnyws/models/primitives/account_data.dart';

class AppState {
  const AppState({this.account});

  final AccountData account;

  AppState copyWith({AccountData account}) {
    return AppState(account: account ?? this.account);
  }
}
