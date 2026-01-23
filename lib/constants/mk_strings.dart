import 'dart:async' show TimeoutException;

import 'package:pnyws/data/entities/exceptions.dart';

class MkStrings {
  static const appName = 'Pnyws';
  static const networkError =
      'Please check your network connection or contact your service provider if the problem persists.';

  static String genericError(dynamic error) {
    if (error is TimeoutException) {
      return 'This action took too long. Please Retry.';
    }
    return error is AppException ? error.message ?? '$error' : '$error';
  }
}
