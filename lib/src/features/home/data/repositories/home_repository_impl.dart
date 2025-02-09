import 'package:expense_managment/src/features/expenses/data/data_source/local/expense_data_source.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<ExpenseModel>> getExpenses(String email) async {
    final ExpenseDataSourceLocal expenseDataSourceLocal =
        ExpenseDataSourceLocal();
    try {
      final expenses = await expenseDataSourceLocal.getExpenses(email);

      return expenses;
    } catch (e) {
      rethrow;
    }
  }
}
