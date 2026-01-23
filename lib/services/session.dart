import 'package:pnyws/environments/environment.dart';

class Session {
  Session({required Environment environment}) : isMock = environment.isMock;

  final bool isMock;
}
