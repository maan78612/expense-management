import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required Map<String, dynamic> body});
  Future<void> register({required Map<String, dynamic> body});
  Future<UserModel?> autoLogin();
  Future<void> signOut();
}
