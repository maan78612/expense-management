
import 'package:expense_managment/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserModel> login({required Map<String, dynamic> body}) async {
    try {
      return UserModel.fromJson({});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register({required Map<String, dynamic> body}) async {
    try {

    } catch (e) {
      rethrow;
    }
  }
}
