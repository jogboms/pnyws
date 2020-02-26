import 'package:pnyws/models/account.dart';

class AppState {
  const AppState({this.account});

  final AccountModel account;

  AppState copyWith({AccountModel account}) {
    return AppState(account: account ?? this.account);
  }
}
