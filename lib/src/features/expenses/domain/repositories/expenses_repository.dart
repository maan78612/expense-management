import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';

abstract class ExpensesRepository {
  Future<void> saveExpenses(String email, ExpenseModel expense);

  Future<List<ExpenseModel>> getExpenses(String email);

  Future<void> updateExpense(String email,ExpenseModel expense);

  Future<void> deleteExpense(int id);
}
