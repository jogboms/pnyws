import 'package:pnyws/environments/environment.dart';
import 'package:pnyws/main.dart' as def;
import 'package:pnyws/repositories/repository.dart';
import 'package:pnyws/services/auth/auth.dart';

void main() => def.main(delay: 1, environment: Environment.PRODUCTION, repository: Repository(auth: AuthImpl()));
