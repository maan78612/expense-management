import 'package:expense_managment/src/core/enums/notification_type.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/services/notification/send_notification.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';
import 'package:expense_managment/src/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:flutter/material.dart';

import 'package:expense_managment/src/core/commons/custom_text_controller.dart';
import 'package:intl/intl.dart';

class ExpenseFormViewModel with ChangeNotifier {
  final ExpensesRepository _expensesRepository;

  ExpenseFormViewModel({ExpensesRepository? repository})
      : _expensesRepository = repository ?? ExpensesRepositoryImpl();
  final CustomTextController titleController = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());
  final CustomTextController amountController = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());
  CustomTextController expenseDate = CustomTextController(
      controller: TextEditingController(), focusNode: FocusNode());
  DateTime? selectedDate;
  CategoryModel? selectedCategory;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // State to manage whether the login button should be enabled
  bool _isBtnEnable = false;

  bool get isBtnEnable => _isBtnEnable;

  /// Sets the loading state and notifies listeners.
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void initMethod(ExpenseModel? expense) {
    if (expense != null) {
      debugPrint("selectedDate = $selectedDate");
      titleController.controller.text = expense.title;
      amountController.controller.text = expense.amount.toString();
      selectedDate = expense.date;
      expenseDate.controller.text =
          DateFormat('yyyy-MM-dd').format(selectedDate!);
      selectedCategory = expense.category;
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  void setCategory(CategoryModel? category) {
    selectedCategory = category;
    notifyListeners();
  }

  Future<void> submitForm(UserModel user, ExpenseModel? expense) async {
    if (selectedDate == null) {
      SnackBarUtils.show('Select date of expenses', SnackBarType.warning);
      return;
    } else if (selectedCategory == null) {
      SnackBarUtils.show('Select category ', SnackBarType.warning);
      return;
    } else {
      final newExpense = ExpenseModel(
        title: titleController.controller.text,
        amount: double.parse(amountController.controller.text),
        category: selectedCategory!,
        date: selectedDate!,
        id: expense?.id ?? DateTime.now().millisecondsSinceEpoch,
      );
      try {
        setLoading(true);
        if (expense != null) {
          await _expensesRepository.updateExpense(user.email, newExpense);
        } else {
          await _expensesRepository.saveExpenses(user.email, newExpense);
        }
        clearForm();
        await sendNotification(newExpense, user);
      } catch (e) {
        SnackBarUtils.show(e.toString(), SnackBarType.error);
      } finally {
        setLoading(false);
      }
    }
  }

  Future<void> sendNotification(ExpenseModel? expense, UserModel user) async {
    return NotificationManager().send(
      title: expense != null ? "Expense Updated" : "Expense Added",
      message: expense != null
          ? "Expense has been updated successfully"
          : "Expense has been added successfully ",
      sendTo: [user.email],
      type:
          expense != null ? NotificationType.warning : NotificationType.success,
    );
  }

  void clearForm() {
    titleController.controller.clear();
    amountController.controller.clear();
    selectedDate = null;
    selectedCategory = null;
    notifyListeners();
  }

  void onChange({
    required CustomTextController con,
    String? Function(String?)? validator,
    required String value,
  }) {
    if (validator != null) {
      con.error = validator(value);
    }
    setEnableBtn();
  }

  /// Determines if the login button should be enabled based on input validation.
  void setEnableBtn() {
    _isBtnEnable = titleController.controller.text.isNotEmpty &&
        amountController.controller.text.isNotEmpty;

    notifyListeners();
  }
}
