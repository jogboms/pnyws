import 'package:equatable/equatable.dart';
import 'package:pnyws/constants/mk_strings.dart';

class NoInternetException extends AppException {
  NoInternetException() : super(MkStrings.networkError);
}

class AppException with EquatableMixin implements Exception {
  AppException([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}
