import 'package:equatable/equatable.dart';
import 'package:pnyws/constants/mk_strings.dart';

class NoInternetException extends MkException {
  NoInternetException() : super(MkStrings.networkError);
}

class MkException with EquatableMixin implements Exception {
  MkException([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}
