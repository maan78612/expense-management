part of 'package:expense_managment/src/features/expenses/presentation/views/expenses_form_view.dart';

class _CategoryDropDown extends ConsumerWidget {
  final ChangeNotifierProvider<ExpenseFormViewModel>
      expenseFormViewModelProvide;

  const _CategoryDropDown(this.expenseFormViewModelProvide);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorMode = ref.watch(colorModeProvider);
    final expenseFormViewModel = ref.watch(expenseFormViewModelProvide);
    return Padding(
        padding: EdgeInsets.only(bottom:  12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category',
              style: PoppinsStyles.medium(
                      color: AppColorHelper.getPrimaryTextColor(colorMode))
                  .copyWith(fontSize: 14.sp)),
          11.verticalSpace,
          CommonInkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: AppColorHelper.getPrimaryTextColor(colorMode),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.sp, vertical: ((50 - 16) / 2).sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: categories.map((CategoryModel category) {
                          return ListTile(
                            leading: Icon(category.icon, color: category.color),
                            title: Text(
                              category.name,
                              style: PoppinsStyles.semiBold(
                                color: AppColorHelper.getScaffoldColor(colorMode),
                              ),
                            ),
                            onTap: () {
                              expenseFormViewModel.setCategory(category);
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              );
            },
            child: AnimatedContainer(
              height: inputFieldHeight,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: AppColorHelper.getScaffoldColor(colorMode),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppColorHelper.borderColor(colorMode), width: 1),
              ),
              child: Row(
                children: [
                  13.horizontalSpace,
                  if (expenseFormViewModel.selectedCategory != null) ...[
                    Icon(expenseFormViewModel.selectedCategory?.icon,
                        color: expenseFormViewModel.selectedCategory?.color),
                    13.horizontalSpace,
                  ],
                  Expanded(
                    child: Text(
                        expenseFormViewModel.selectedCategory?.name ??
                            'Select Category',
                        style: PoppinsStyles.regular(
                                color:
                                    expenseFormViewModel.selectedCategory != null
                                        ? AppColorHelper.getPrimaryTextColor(
                                            colorMode)
                                        : AppColorHelper.hintColor(colorMode))
                            .copyWith(fontSize: 15.sp)),
                  ),
                  Icon(Icons.arrow_drop_down,
                      size: 24.sp,
                      color: AppColorHelper.getPrimaryTextColor(colorMode)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
