import 'package:expense_managment/src/features/expenses/data/data_source/local/expense_data_source.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpenseDataSourceLocal _expenseDataSourceLocal =
      ExpenseDataSourceLocal();

  @override
  Future<void> saveExpenses(String email, ExpenseModel expense) async {
    try {
      await _expenseDataSourceLocal.saveExpense(email, expense);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String email) async {
    try {
      final expenses = await _expenseDataSourceLocal.getExpenses(email);

      return expenses;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateExpense(String email,ExpenseModel expense) async {
    try {
      await _expenseDataSourceLocal.updateExpense(email,expense);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(int id) async {
    try {
      await _expenseDataSourceLocal.deleteExpense(id);
    } catch (e) {
      rethrow;
    }
  }
}
