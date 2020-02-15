import 'package:pnyws/repositories/auth_repository.dart';

class AuthMockImpl implements AuthRepository {
  @override
  Future<Map<String, int>> getAccount() async {
    await Future<void>.delayed(const Duration(seconds: 0));
    return <String, int>{"id": 1};
  }
}
