part of 'package:expense_managment/src/features/dashboard/presentation/views/dashboard_screen/dashboard_screen.dart';

class _BottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _BottomNavigationBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetContent(
      selectedIndex: selectedIndex,
      onItemSelected: onItemSelected,
    );
  }
}

class BottomSheetContent extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomSheetContent({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorMode = ref.watch(colorModeProvider);
    final icons = [AppImages.home, AppImages.formIcon, AppImages.setting];
    final padding = MediaQuery.of(context).padding;
    return Container(
      padding: EdgeInsets.only(top: 16.sp).add(padding),
      decoration:
          BoxDecoration(color: AppColorHelper.getPrimaryColor(colorMode)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(index),
              child: Image.asset(
                icons[index],
                color: selectedIndex == index
                    ? AppColorHelper.getScaffoldColor(colorMode)
                    : AppColorHelper.getPrimaryTextColor(colorMode),
                width: 28.sp,
                height: 28.sp,
              ),
            ),
          );
        }),
      ),
    );
  }
}
