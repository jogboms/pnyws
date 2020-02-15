import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/main.dart' as def;
import 'package:pnyws/repositories/repository.dart';
import 'package:pnyws/services/auth/auth.dart';

void main() => def.main(delay: 2, environment: Environment.MOCK, repository: Repository(auth: AuthMockImpl()));
