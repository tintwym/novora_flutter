import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController {
  AuthController({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();
  final AuthRepository _repository;

  AuthRepository get repository => _repository;

  Future<UserModel> login(String email, String password) =>
      _repository.login(email, password);

  Future<UserModel> register({
    required String email,
    required String password,
  }) => _repository.register(email: email, password: password);

  Future<void> forgotPassword(String email) =>
      _repository.forgotPassword(email);
}
