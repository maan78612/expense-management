import 'package:expense_managment/src/core/enums/expense_sort_enum.dart';
import 'package:expense_managment/src/core/enums/notification_type.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/services/notification/send_notification.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:flutter/material.dart';

class ExpenseListViewModel with ChangeNotifier {
  final ExpensesRepository _expenseRepository;

  ExpenseListViewModel({ExpensesRepository? repository})
      : _expenseRepository = repository ?? ExpensesRepositoryImpl();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Sets the loading state and notifies listeners.
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<ExpenseModel> expenses = [];
  Map<DateTime, List<ExpenseModel>> groupedExpenses = {};

  SortOrder _sortOrder = SortOrder.descending;

  SortOrder get sortOrder => _sortOrder;

  Future<void> fetchExpenses(UserModel user) async {
    try {
      setLoading(true);
      expenses.clear();
      expenses = await _expenseRepository.getExpenses(user.email);
      debugPrint("fetchExpenses = ${expenses.length}");
      _groupAndSortExpenses();
    } catch (e) {
      SnackBarUtils.show(e.toString(), SnackBarType.error);
    } finally {
      setLoading(false);
    }
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    _groupAndSortExpenses();
    notifyListeners();
  }

  void _groupAndSortExpenses() {
    final map = <DateTime, List<ExpenseModel>>{};
    for (final expense in expenses) {
      final date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      map.putIfAbsent(date, () => []).add(expense);
    }

    groupedExpenses = Map.fromEntries(map.entries.toList()
      ..sort((a, b) => _sortOrder == SortOrder.descending
          ? b.key.compareTo(a.key)
          : a.key.compareTo(b.key)));
  }

  Future<void> deleteExpense(ExpenseModel expense,UserModel user) async {
    try {
      setLoading(true);
      await _expenseRepository.deleteExpense(expense.id);

      // Remove from local list
      expenses.removeWhere((ex) => ex.id == expense.id);

      // Regroup and sort expenses
      _groupAndSortExpenses();  // <-- Add this line
      NotificationManager().send(
          title:  "Expense Deleted",
          message: "Expense has been deleted successfully"
          ,
          sendTo: [
            user.email,
          ],
          type: NotificationType.failed

      );
      notifyListeners();
    } catch (e) {
      SnackBarUtils.show(e.toString(), SnackBarType.error);
    } finally {
      setLoading(false);
    }
  }
}
