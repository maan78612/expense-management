import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:expense_managment/src/features/home/domain/model/chart_info.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_managment/src/core/enums/tab_bar_enum.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';
import 'package:expense_managment/src/features/home/data/repositories/home_repository_impl.dart';
import 'package:expense_managment/src/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewModel with ChangeNotifier {
  /// Repository for home-related operations
  final HomeRepository _homeRepository = HomeRepositoryImpl();

  /// Loading state to indicate when a process is running
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// The currently selected tab in the home view
  TabBarEnum selectedTab = TabBarEnum.pie;

  /// Sets the loading state and notifies listeners.
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Updates the selected tab and notifies listeners if the selection changes.
  void setTabView(TabBarEnum type) {
    if (selectedTab != type) {
      selectedTab = type;
      notifyListeners();
    }
  }

  /// Resets the month if the saved month is not the current month.
  /// This includes resetting the user's remaining balance and their beneficiaries' balances.
  Future<void> initMethod(UserModel user) async {
    _totalChartInfo = await _calculateTotalChartInfo(user);

    notifyListeners();
  }

  Future<List<ChartInfoModel>> _calculateTotalChartInfo(UserModel user) async {
    final List<ExpenseModel> userExpenses =
        await _homeRepository.getExpenses(user.email);

    if (userExpenses.isNotEmpty) {
      return categories.map((category) {
        final double totalAmount = userExpenses
            .where((expense) => expense.category.id == category.id)
            .fold(0, (sum, expense) => sum + expense.amount);

        return ChartInfoModel(category: category, amount: totalAmount);
      }).toList();
    } else {
      return [];
    }
  }

  ///*---------------------------------------------------------------------*///
  ///*-------------------------> Chart <-----------------------------------*///
  ///*---------------------------------------------------------------------*///
  List<ChartInfoModel> _totalChartInfo = [];

  /// ---------------------------> Pie chart <----------------------------///
  List<ChartInfoModel> get totalChartInfo => _totalChartInfo;

  double get totalExpenses =>
      _totalChartInfo.fold(0, (sum, expense) => sum + expense.amount);

  List<PieChartSectionData> pieChartSections(ColorMode colorMode) {
    return _totalChartInfo.map((expense) {
      final double percentage = (expense.amount / totalExpenses) * 100;
      return PieChartSectionData(
        color: expense.category.color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50.sp,
        titleStyle: PoppinsStyles.bold(
                color: AppColorHelper.getPrimaryTextColor(colorMode))
            .copyWith(fontSize: 14.sp),

        // Custom badge widget
        badgePositionPercentageOffset: 0.98,
        // Position badge outside the chart
        gradient: LinearGradient(
          colors: [
            expense.category.color.withOpacity(0.8),
            expense.category.color.withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderSide: BorderSide(
          color: AppColorHelper.getPrimaryTextColor(colorMode).withOpacity(0.5),
          width: 2,
        ),
        showTitle: true,
      );
    }).toList();
  }

  void _showTooltip(BuildContext context, FlTouchEvent event,
      PieTouchResponse? touchResponse) {
    if (touchResponse == null || touchResponse.touchedSection == null) return;

    final sectionIndex = touchResponse.touchedSection!.touchedSectionIndex;
    // Check if the sectionIndex is valid
    if (sectionIndex < 0 || sectionIndex >= _totalChartInfo.length) return;
    final expense = _totalChartInfo[sectionIndex];

    final overlayState = Overlay.of(context); // Use the widget's context
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: (event.localPosition?.dx ?? 0.0) + offset.dx,
        top: (event.localPosition?.dy ?? 0.0) + offset.dy - 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${expense.category.name}\n${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  /// Update pieTouchData to accept BuildContext
  PieTouchData getPieTouchData(BuildContext context) {
    return PieTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
        _showTooltip(context, event, touchResponse); // Pass context from widget
      },
    );
  }

  /// ---------------------------> Bar chart <----------------------------///
  List<BarChartGroupData> get barChartGroups {
    return _totalChartInfo.asMap().entries.map((entry) {
      final index = entry.key;
      final expense = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: expense.amount,
            gradient: LinearGradient(
              colors: [
                expense.category.color.withOpacity(0.8),
                expense.category.color.withOpacity(0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 10,
            borderRadius: BorderRadius.circular(8),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: totalExpenses,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  /// Bar chart titles (category names)
  List<String> get barChartTitles {
    return _totalChartInfo.map((category) => category.category.name).toList();
  }

  /// Bar chart axis titles and styling
  FlTitlesData barTitlesData(ColorMode colorMode) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                barChartTitles[value.toInt()],
                style: PoppinsStyles.regular(
                  color: AppColorHelper.getPrimaryTextColor(colorMode),
                ).copyWith(fontSize: 10.sp),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: PoppinsStyles.regular(
                color: AppColorHelper.getPrimaryTextColor(colorMode),
              ).copyWith(fontSize: 8.sp),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  /// Bar chart grid styling
  FlGridData get barGridData {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: totalExpenses / 5,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
    );
  }

  /// Bar chart border styling
  FlBorderData get barBorderData {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        left: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
    );
  }
}
