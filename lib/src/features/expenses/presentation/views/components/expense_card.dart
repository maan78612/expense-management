part of 'package:expense_managment/src/features/expenses/presentation/views/expense_list_view.dart';

class _ExpenseCard extends ConsumerWidget {
  final ExpenseModel expense;
  final ChangeNotifierProvider<ExpenseListViewModel>
      expenseListViewModelProvider;

  const _ExpenseCard(
      {required this.expenseListViewModelProvider, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseListViewModel = ref.watch(expenseListViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return Slidable(
      key: Key(expense.id.toString()),
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (BuildContext context) {
              _showDeleteDialog(context, colorMode, expenseListViewModel, ref);
            },
          ),
          SlidableAction(
            backgroundColor: AppColors.greenColor,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (BuildContext context) async {
              await CustomNavigation().push(ExpenseFormView(
                expense: expense,
              ));
              expenseListViewModel.fetchExpenses(ref.read(userModelProvider));
            },
          )
        ],
      ),
      child: Card(
        margin: EdgeInsets.all(8.w),
        color: AppColorHelper.cardColor(colorMode),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              categoryIndicator(expense.category),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: PoppinsStyles.regular(
                              color:
                                  AppColorHelper.getPrimaryTextColor(colorMode))
                          .copyWith(fontSize: 16.sp),
                    ),
                    4.verticalSpace,
                    Text(
                      expense.category.name,
                      style: PoppinsStyles.regular(
                              color: AppColorHelper.getSecondaryTextColor(
                                  colorMode))
                          .copyWith(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberFormat.currency(symbol: 'AED ')
                        .format(expense.amount),
                    style: PoppinsStyles.regular(
                            color:
                                AppColorHelper.getPrimaryTextColor(colorMode))
                        .copyWith(fontSize: 16.sp),
                  ),
                  4.verticalSpace,
                  Text(
                    DateFormat('HH:mm').format(expense.date),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryIndicator(CategoryModel category) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            category.color.withOpacity(0.8),
            category.color.withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Icon(
        category.icon, // Replace with a relevant icon
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ColorMode colorMode,
      ExpenseListViewModel expenseListViewModel, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
          title: Text(
            'Delete Expense',
            style: PoppinsStyles.semiBold(
                    color: AppColorHelper.getPrimaryTextColor(colorMode))
                .copyWith(fontSize: 16.sp),
          ),
          content: Text('Are you sure you want to delete?',
              style: PoppinsStyles.regular(
                      color: AppColorHelper.getSecondaryTextColor(colorMode))
                  .copyWith(fontSize: 12.sp)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: PoppinsStyles.medium(
                          color: AppColorHelper.getPrimaryTextColor(colorMode))
                      .copyWith(fontSize: 14.sp)),
              onPressed: () {
                CustomNavigation().pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Delete',
                  style: PoppinsStyles.medium(color: AppColors.redColor)
                      .copyWith(fontSize: 14.sp)),
              onPressed: () {
                CustomNavigation().pop();
                expenseListViewModel.deleteExpense(
                    expense, ref.read(userModelProvider));
              },
            ),
          ],
        );
      },
    );
  }
}
