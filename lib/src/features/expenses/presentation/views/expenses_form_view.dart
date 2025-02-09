import 'package:expense_managment/src/core/commons/common_app_bar.dart';
import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/core/constants/text_field_validator.dart';
import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/presentation/viewmodels/expenses_form_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:expense_managment/src/core/commons/custom_input_field.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';

part 'components/category_drop_down.dart';

part 'components/date_picker.dart';

class ExpenseFormView extends ConsumerStatefulWidget {
  final ExpenseModel? expense;

  const ExpenseFormView({super.key, this.expense});

  @override
  ConsumerState<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends ConsumerState<ExpenseFormView> {
  final expenseFormViewModelProvider =
      ChangeNotifierProvider<ExpenseFormViewModel>((ref) {
    return ExpenseFormViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expenseFormViewModelProvider).initMethod(widget.expense);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenseFormViewModel = ref.watch(expenseFormViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return CustomLoader(
      isLoading: expenseFormViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        appBar: CommonAppBar(
          onTap: () => CustomNavigation().pop(),
          title: widget.expense == null ? 'Add New Expense' : 'Edit Expense',
          colorMode: colorMode,
        ),
        body: Padding(
          padding: EdgeInsets.all(hMargin),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                  hint: "John Doe",
                  title: "Title",
                  textInputAction: TextInputAction.next,
                  controller: expenseFormViewModel.titleController,
                  onChange: (value) {
                    expenseFormViewModel.onChange(
                        con: expenseFormViewModel.titleController,
                        value: value,
                        validator: TextFieldValidator.validateField);
                  },
                  colorMode: colorMode,
                ),

                CustomInputField(
                  hint: "12",
                  title: "Amount",
                  textInputAction: TextInputAction.next,
                  controller: expenseFormViewModel.amountController,
                  onChange: (value) {
                    expenseFormViewModel.onChange(
                        con: expenseFormViewModel.amountController,
                        value: value,
                        validator: TextFieldValidator.validateField);
                  },
                  colorMode: colorMode,
                ),

                // Category Dropdown
                _CategoryDropDown(expenseFormViewModelProvider),

                // Date Picker
                _ExpenseDatePicker(expenseFormViewModelProvider),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(left: hMargin, right: hMargin, bottom: hMargin),
          child: CustomButton(
              bgColor: AppColorHelper.getPrimaryColor(colorMode),
              onPressed: () {
                expenseFormViewModel.submitForm(
                    ref.read(userModelProvider), widget.expense);
              },
              title: widget.expense == null ? "Add Expense" : "Update Expense"),
        ),
      ),
    );
  }
}
