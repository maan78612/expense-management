part of 'package:expense_managment/src/features/home/presentation/views/home_view.dart';

class _HomeTabBar extends ConsumerWidget {
  final ChangeNotifierProvider<HomeViewModel> homeViewModelProvider;
  final ColorMode colorMode;

  const _HomeTabBar(
      {super.key,
      required this.homeViewModelProvider,
      required this.colorMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final selectedIndex = TabBarEnum.values.indexOf(homeViewModel.selectedTab);

    return Container(
      padding: EdgeInsets.all(4.sp),
      margin: EdgeInsets.symmetric(horizontal: hMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32.r)),
        color: AppColorHelper.getPrimaryColor(colorMode).withOpacity(0.4),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: (MediaQuery.of(context).size.width - (2 * hMargin)) /
                TabBarEnum.values.length *
                selectedIndex,

            /// Adjust the width calculation to ensure it fits on larger screens
            width: (MediaQuery.of(context).size.width - (2 * hMargin)) /
                    TabBarEnum.values.length -
                8.sp,
            height: 40.h,
            child: Container(
              decoration: BoxDecoration(
                color: AppColorHelper.getPrimaryColor(colorMode),
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: TabBarEnum.values.map((status) {
              return _StatusButton(
                tabBarEnum: status,
                isSelected: homeViewModel.selectedTab == status,
                onTap: () => homeViewModel.setTabView(status), colorMode: colorMode,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends ConsumerWidget {
  final TabBarEnum tabBarEnum;
  final bool isSelected;
  final ColorMode colorMode;
  final VoidCallback onTap;

  const _StatusButton({
    super.key,
    required this.tabBarEnum,
    required this.isSelected,
    required this.colorMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: CommonInkWell(
        onTap: onTap,
        child: SizedBox(
          height: 40.sp,
          child: Center(
            child: Text(
              statusToString(tabBarEnum),
              style: isSelected
                  ? PoppinsStyles.medium(color: AppColorHelper.getScaffoldColor(colorMode))
                      .copyWith(fontSize: 13.sp)
                  : PoppinsStyles.regular(
                          color: AppColorHelper.getPrimaryTextColor(colorMode))
                      .copyWith(
                      fontSize: 13.sp,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  String statusToString(TabBarEnum tabBarEnum) {
    switch (tabBarEnum) {
      case TabBarEnum.pie:
        return 'Pie Chart';
      case TabBarEnum.bar:
        return 'Bar Char';
    }
  }
}
