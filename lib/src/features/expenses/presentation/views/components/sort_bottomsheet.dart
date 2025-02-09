part of 'package:expense_managment/src/features/expenses/presentation/views/expense_list_view.dart';

class _SortBottomSheet extends ConsumerWidget {
  final ChangeNotifierProvider<ExpenseListViewModel>
      expenseListViewModelProvider;

  const _SortBottomSheet(
      {required this.expenseListViewModelProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseListViewModel = ref.watch(expenseListViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return Container(
      padding: EdgeInsets.all(hMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, colorMode),
          _buildSortOption(
            context,
            colorMode: colorMode,
            title: 'Newest First',
            isSelected: expenseListViewModel.sortOrder == SortOrder.descending,
            onTap: () => _handleSortSelection(
                context, SortOrder.descending, expenseListViewModel),
          ),
          _buildSortOption(
            context,
            colorMode: colorMode,
            title: 'Oldest First',
            isSelected: expenseListViewModel.sortOrder == SortOrder.ascending,
            onTap: () => _handleSortSelection(
                context, SortOrder.ascending, expenseListViewModel),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorMode colorMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Text(
        'Sort By',
        style: PoppinsStyles.semiBold(
          color: AppColorHelper.getPrimaryTextColor(colorMode),
        ).copyWith(fontSize: 18.sp),
      ),
    );
  }

  Widget _buildSortOption(BuildContext context,
      {required String title,
      required bool isSelected,
      required VoidCallback onTap,
      required ColorMode colorMode}) {
    return CommonInkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColorHelper.borderColor(colorMode),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: PoppinsStyles.regular(
                color: AppColorHelper.getPrimaryTextColor(colorMode),
              ).copyWith(fontSize: 16.sp),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColorHelper.getPrimaryColor(colorMode),
                size: 20.w,
              )
          ],
        ),
      ),
    );
  }

  void _handleSortSelection(BuildContext context, SortOrder order,
      ExpenseListViewModel expenseListViewModel) {
    expenseListViewModel.setSortOrder(order);
    CustomNavigation().pop();
  }
}
