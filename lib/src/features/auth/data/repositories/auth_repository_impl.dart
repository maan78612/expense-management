import 'package:expense_managment/src/features/auth/data/data_source/remote/auth_data_source.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource = AuthDataSource();

  @override
  Future<UserModel> login({required Map<String, dynamic> body}) async {
    try {
      final email = body['email'] as String;
      final password = body['password'] as String;

      return await authDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Add any repository-level error handling here
      rethrow;
    }
  }

  @override
  Future<UserModel> register({required Map<String, dynamic> body}) async {
    try {
      final email = body['email'] as String;
      final password = body['password'] as String;
      final name = body['name'] as String;

      return await authDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> autoLogin() async {
    try {
      return await authDataSource.autoLogin();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
