import 'package:expense_managment/src/core/commons/common_app_bar.dart';
import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/enums/expense_sort_enum.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/core/services/export.dart';
import 'package:expense_managment/src/core/utilities/snack_bar.dart';
import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/expenses/presentation/viewmodels/expense_list_viewmodel.dart';
import 'package:expense_managment/src/features/expenses/presentation/views/expenses_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

part 'components/sort_bottomsheet.dart';

part 'components/expense_card.dart';

class ExpensesListView extends ConsumerStatefulWidget {
  const ExpensesListView({super.key});

  @override
  ConsumerState<ExpensesListView> createState() => _ExpensesListViewState();
}

class _ExpensesListViewState extends ConsumerState<ExpensesListView> {
  final expenseListViewModelProvider =
      ChangeNotifierProvider<ExpenseListViewModel>((ref) {
    return ExpenseListViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(expenseListViewModelProvider)
          .fetchExpenses(ref.read(userModelProvider));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenseListViewModel = ref.watch(expenseListViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);

    return CustomLoader(
      isLoading: expenseListViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        appBar: CommonAppBar(
          title: "Expenses",
          colorMode: colorMode,
          actions: [
            CommonInkWell(
                onTap: () =>
                    _showExportDialog(context, colorMode, expenseListViewModel),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'export',
                    style: PoppinsStyles.medium(
                            color: AppColorHelper.getPrimaryColor(colorMode))
                        .copyWith(fontSize: 14.sp),
                  ),
                )),
            CommonInkWell(
                onTap: () => _showSortBottomSheet(context, colorMode),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.sort,
                    size: 24.sp,
                    color: AppColorHelper.getIconColor(colorMode),
                  ),
                )),
          ],
        ),
        body: SafeArea(
          child: expenseListViewModel.expenses.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final date = expenseListViewModel.groupedExpenses.keys
                              .elementAt(index);
                          final dailyExpenses =
                              expenseListViewModel.groupedExpenses[date]!;

                          return StickyHeader(
                            header: _buildDateHeader(
                                date, dailyExpenses, context, colorMode),
                            content: Column(
                              children: dailyExpenses
                                  .map((expense) => _ExpenseCard(
                                        expense: expense,
                                        expenseListViewModelProvider:
                                            expenseListViewModelProvider,
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                        childCount: expenseListViewModel.groupedExpenses.length,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("No record found",
                      style: PoppinsStyles.bold(
                        color: AppColorHelper.getPrimaryTextColor(colorMode),
                      ).copyWith(fontSize: 24.sp))),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await CustomNavigation().push(ExpenseFormView());
            expenseListViewModel.fetchExpenses(ref.read(userModelProvider));
          },
          icon: Icon(Icons.add),
          label: Text('Add Expense'),
          backgroundColor: AppColorHelper.getPrimaryColor(colorMode),
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date, List<ExpenseModel> expenses,
      BuildContext context, ColorMode colorMode) {
    return Container(
      height: 60.h,
      color: AppColorHelper.hintColor(colorMode),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, MMM d').format(date),
            style: PoppinsStyles.light(
                    color: AppColorHelper.getScaffoldColor(colorMode))
                .copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Chip(
            color: WidgetStateProperty.all(
                AppColorHelper.getPrimaryColor(colorMode)),
            label: Text(
              '${expenses.length} items · ${_totalDailyAmount(expenses)}',
              style: PoppinsStyles.regular(
                      color: AppColorHelper.getScaffoldColor(colorMode))
                  .copyWith(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  String _totalDailyAmount(List<ExpenseModel> expenses) {
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    return NumberFormat.currency(symbol: 'AED').format(total);
  }

  void _showSortBottomSheet(BuildContext context, ColorMode colorMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
      builder: (context) => _SortBottomSheet(
        expenseListViewModelProvider: expenseListViewModelProvider,
      ),
    );
  }

  void _showExportDialog(BuildContext context, ColorMode colorMode,
      ExpenseListViewModel expenseListViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColorHelper.getPrimaryTextColor(colorMode),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Option to proceed',
                style: PoppinsStyles.regular(
                        color: AppColorHelper.getScaffoldColor(colorMode))
                    .copyWith(fontSize: 16.sp),
              ),
              15.verticalSpace,
              Divider(),
              15.verticalSpace,
              CustomButton(
                  bgColor: AppColorHelper.getPrimaryColor(colorMode),
                  title: 'Export to CSV',
                  onPressed: () async {
                    try {
                      await ExportService.exportToCSV(
                          expenseListViewModel.expenses);

                    } catch (e) {
                      SnackBarUtils.show(e.toString(), SnackBarType.error);
                    }
                  }),
              20.verticalSpace,
              CustomButton(
                  bgColor: AppColorHelper.getPrimaryColor(colorMode),
                  title: 'Export to PDF',
                  onPressed: () async {
                    try {
                      await ExportService.exportToPDF(
                          expenseListViewModel.expenses);
                    } catch (e) {
                      SnackBarUtils.show(e.toString(), SnackBarType.error);
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
