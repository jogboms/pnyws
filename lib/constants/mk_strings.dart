import 'dart:async' show TimeoutException;

import 'package:pnyws/wrappers/mk_exceptions.dart';

class MkStrings {
  static const String appName = "Tubo";
  static const String networkError =
      "Please check your network connection or contact your service provider if the problem persists.";
  static const String errorMessage = "An error occurred. Please try again.";
  static const String fixErrors = "Please fix the errors in red before submitting";

  static String genericError(dynamic error) {
    if (error is TimeoutException) {
      return "This action took too long. Please Retry.";
    }
    return error is MkException ? error.message : "$error";
  }
}
