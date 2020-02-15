import 'package:flutter/foundation.dart';
import 'package:pnyws/environments/environment.dart';

class Session {
  Session({@required Environment environment})
      : assert(environment != null),
        isMock = environment.isMock;

  final bool isMock;
}
