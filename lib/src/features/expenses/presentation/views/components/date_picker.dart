part of 'package:expense_managment/src/features/expenses/presentation/views/expenses_form_view.dart';

class _ExpenseDatePicker extends ConsumerWidget {
  final ChangeNotifierProvider<ExpenseFormViewModel>
      expenseFormViewModelProvide;

  const _ExpenseDatePicker(this.expenseFormViewModelProvide);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editProfileViewModel = ref.watch(expenseFormViewModelProvide);
    final colorMode = ref.watch(colorModeProvider);
    return CommonInkWell(
      onTap: () {
        _selectDateOfBirthFunction(context, editProfileViewModel, colorMode);
      },
      child: CustomInputField(
        title: "Date of expense",
        enable: false,
        hint: "Enter expense data",
        textInputAction: TextInputAction.done,
        controller: editProfileViewModel.expenseDate,
        colorMode: colorMode,
      ),
    );
  }

  Future<void> _selectDateOfBirthFunction(BuildContext context,
      ExpenseFormViewModel editProfileViewModel, ColorMode colorMode) async {
    editProfileViewModel.selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  surface: AppColorHelper.getScaffoldColor(colorMode),
                  primary: AppColorHelper.getPrimaryColor(colorMode),
                  // Selected date's circle color
                  onPrimary: colorMode == ColorMode.light
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  // Text color on selected date
                  onSurface: colorMode == ColorMode.light
                      ? AppColors.greyColor
                      : AppColors.whiteColor)

              // Background color of the date picker
              ),
          child: child!,
        );
      },
    );
    debugPrint("selectedDate = ${editProfileViewModel.selectedDate}");
    if (editProfileViewModel.selectedDate != null) {
      editProfileViewModel.expenseDate.controller.text =
          DateFormat('yyyy-MM-dd').format(editProfileViewModel.selectedDate!);
    }
  }
}
