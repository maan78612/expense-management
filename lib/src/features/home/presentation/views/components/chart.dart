part of 'package:expense_managment/src/features/home/presentation/views/home_view.dart';

class _Chart extends ConsumerWidget {
  final ChangeNotifierProvider<HomeViewModel> homeViewModelProvider;

  const _Chart(this.homeViewModelProvider);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);
    return Expanded(
      child: homeViewModel.totalChartInfo.isNotEmpty
          ? ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: hMargin),
                  height: 250.sp,
                  child: homeViewModel.selectedTab == TabBarEnum.pie
                      ? PieChart(
                          PieChartData(
                            sections: homeViewModel.pieChartSections(colorMode),
                            centerSpaceRadius: 75.sp,
                            pieTouchData:
                                homeViewModel.getPieTouchData(context),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 3,
                          ),
                        )
                      : SingleChildScrollView(
                          // Make Bar Chart scrollable
                          scrollDirection:
                              Axis.horizontal, // Horizontal scrolling
                          child: SizedBox(
                            width: homeViewModel.totalChartInfo.length * 90,
                            // Adjust width based on number of categories
                            child: BarChart(
                              BarChartData(
                                barGroups: homeViewModel.barChartGroups,
                                titlesData:
                                    homeViewModel.barTitlesData(colorMode),
                                gridData: homeViewModel.barGridData,
                                borderData: FlBorderData(show: false),
                                alignment: BarChartAlignment.spaceAround,
                                maxY: homeViewModel.totalExpenses,
                              ),
                            ),
                          ),
                        ),
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMargin),
                  child: Text(
                    "Categories :",
                    style: PoppinsStyles.semiBold(
                      color: AppColorHelper.getPrimaryTextColor(colorMode),
                    ).copyWith(fontSize: 19.sp),
                  ),
                ),
                10.verticalSpace,
                _categoryList(homeViewModel, colorMode, context),
                20.verticalSpace,
              ],
            )
          : Center(
              child: Text("No record found",
                  style: PoppinsStyles.bold(
                    color: AppColorHelper.getPrimaryTextColor(colorMode),
                  ).copyWith(fontSize: 24.sp))),
    );
  }

  Column _categoryList(
      HomeViewModel homeViewModel, ColorMode colorMode, BuildContext context) {
    return Column(
      children: List.generate(homeViewModel.totalChartInfo.length, (index) {
        final expense = homeViewModel.totalChartInfo[index];
        final percentage = (expense.amount / homeViewModel.totalExpenses) * 100;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: hMargin),
          color: AppColorHelper.cardColor(colorMode),
          elevation: 2,
          // Add shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Leading Icon with Gradient Background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        expense.category.color.withOpacity(0.8),
                        expense.category.color.withOpacity(0.2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Icon(
                    expense.category.icon, // Replace with a relevant icon
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                16.horizontalSpace, // Spacing
                // Category Name and Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category.name,
                        style: PoppinsStyles.medium(
                          color: AppColorHelper.getPrimaryTextColor(colorMode),
                        ).copyWith(fontSize: 14.sp),
                      ),
                      const SizedBox(height: 8), // Spacing
                      // Custom Progress Bar
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Stack(
                          children: [
                            // Background
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            // Progress
                            Container(
                              width: (percentage / 100) *
                                  MediaQuery.of(context).size.width *
                                  0.6, // Adjust width
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: [
                                    expense.category.color.withOpacity(0.8),
                                    expense.category.color.withOpacity(0.2),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                16.horizontalSpace,
                // Percentage Text
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: PoppinsStyles.medium(
                    color: AppColorHelper.getSecondaryTextColor(colorMode),
                  ).copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
