import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:expense_managment/src/features/expenses/presentation/viewmodels/expense_list_viewmodel.dart';
import 'package:expense_managment/src/features/expenses/presentation/viewmodels/expenses_form_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'expense_viewmodel_test.mocks.dart';

/// Generate mocks for ExpensesRepository.
@GenerateMocks([ExpensesRepository])
// Note: Do NOT annotate the test subclass with @GenerateMocks.



///*----------> make TestExpenseFormViewModel from actual ExpenseFormViewModel
/// to avoid send notification by overridding it      < ------------ */

class TestExpenseFormViewModel extends ExpenseFormViewModel {
  TestExpenseFormViewModel({required ExpensesRepository expensesRepository})
      : super(repository: expensesRepository);

  @override
  Future<void> sendNotification(ExpenseModel? expense, UserModel user) async {
    // Override to do nothing during tests.
  }
}

void main() {
  // Initialize the Flutter binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  late ExpenseListViewModel expenseListViewModel;
  late ExpenseFormViewModel expenseFormViewModel;
  late MockExpensesRepository mockExpensesRepository;

  setUp(() {
    mockExpensesRepository = MockExpensesRepository();
    expenseListViewModel =
        ExpenseListViewModel(repository: mockExpensesRepository);
    // Use the test subclass for ExpenseFormViewModel.
    expenseFormViewModel =
        TestExpenseFormViewModel(expensesRepository: mockExpensesRepository);
  });

  group('ExpenseListViewModel Tests', () {
    test('fetchExpenses', () async {
      // Arrange
      final user = UserModel(
          email: 'test@example.com', name: 'John', createdAt: DateTime.now());
      final expense1 = ExpenseModel(
        id: 1,
        title: 'Lunch',
        amount: 12.5,
        category: categories[0],
        date: DateTime(2025, 2, 10),
      );
      final expense2 = ExpenseModel(
        id: 2,
        title: 'Dinner',
        amount: 20.0,
        category: categories[0],
        date: DateTime(2025, 2, 10),
      );

      when(mockExpensesRepository.getExpenses(user.email))
          .thenAnswer((_) async => [expense1, expense2]);

      // Act
      await expenseListViewModel.fetchExpenses(user);

      // Assert
      expect(expenseListViewModel.expenses, [expense1, expense2]);
    });

    test('deleteExpense removes expense from list ', () async {
      // Arrange
      final user = UserModel(
          email: 'test@example.com', name: 'John', createdAt: DateTime.now());
      final expense = ExpenseModel(
        id: 1,
        title: 'Coffee',
        amount: 4.0,
        category: categories[1],
        date: DateTime(2025, 2, 11),
      );
      // Pre-populate the view model with one expense.
      expenseListViewModel.expenses = [expense];

      when(mockExpensesRepository.deleteExpense(expense.id))
          .thenAnswer((_) async => Future.value());

      // Act
      await expenseListViewModel.deleteExpense(expense, user);

      // Assert
      expect(expenseListViewModel.expenses, isEmpty);
    });
  });

  group('ExpenseFormViewModel Tests', () {
    test('submitForm calls saveExpenses for new expense with correct data', () async {
      // Arrange
      final user = UserModel(
          email: 'test@example.com', name: 'John', createdAt: DateTime.now());

      // Set up form field values.
      expenseFormViewModel.titleController.controller.text = 'Groceries';
      expenseFormViewModel.amountController.controller.text = '50.0';
      expenseFormViewModel.selectedDate = DateTime(2025, 2, 13);
      expenseFormViewModel.selectedCategory = categories[3];

      // Stub the repository method to simulate a successful save.
      when(mockExpensesRepository.saveExpenses(any, any))
          .thenAnswer((_) async => Future.value());

      // Act: Submit the form.
      await expenseFormViewModel.submitForm(user, null);

      // Assert:
      // Verify that saveExpenses was called once and capture its argument.
      final capturedExpenses = verify(mockExpensesRepository.saveExpenses(user.email, captureAny)).captured;
      expect(capturedExpenses, hasLength(1));
      final capturedExpense = capturedExpenses.single as ExpenseModel;

      // Verify that the captured expense contains the expected data.
      expect(capturedExpense.title, equals('Groceries'));
      expect(capturedExpense.amount, equals(50.0));
      expect(capturedExpense.date, equals(DateTime(2025, 2, 13)));
      expect(capturedExpense.category, equals(categories[3]));
    });


    test('submitForm calls updateExpense for existing expense and clears form', () async {
      // Arrange
      final user = UserModel(
          email: 'test@example.com', name: 'John', createdAt: DateTime.now());
      final existingExpense = ExpenseModel(
        id: 100,
        title: 'Old Expense',
        amount: 30.0,
        category: categories[4],
        date: DateTime(2025, 2, 14),
      );
      // Initialize the form with an existing expense.
      expenseFormViewModel.initMethod(existingExpense);
      // Change some values.
      expenseFormViewModel.titleController.controller.text = 'Updated Expense';
      expenseFormViewModel.amountController.controller.text = '35.0';
      expenseFormViewModel.selectedDate = DateTime(2025, 2, 15);
      expenseFormViewModel.selectedCategory = categories[5];

      when(mockExpensesRepository.updateExpense(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await expenseFormViewModel.submitForm(user, existingExpense);

      // Assert
      verify(mockExpensesRepository.updateExpense(user.email, any)).called(1);

      // After submission, the form should be cleared.
      expect(expenseFormViewModel.titleController.controller.text, isEmpty);
      expect(expenseFormViewModel.amountController.controller.text, isEmpty);
      expect(expenseFormViewModel.selectedDate, isNull);
      expect(expenseFormViewModel.selectedCategory, isNull);
      expect(expenseFormViewModel.isLoading, isFalse);
    });
  });
}
