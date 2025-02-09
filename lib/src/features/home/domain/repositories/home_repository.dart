import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';

abstract class HomeRepository {
  Future<List<ExpenseModel>> getExpenses(String email);
}
