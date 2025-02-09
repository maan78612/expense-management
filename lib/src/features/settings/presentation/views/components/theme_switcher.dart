part of 'package:expense_managment/src/features/settings/presentation/views/setting_view.dart';

class _ThemeSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the current color mode
    final colorMode = ref.watch(colorModeProvider);

    return Padding(
      padding: EdgeInsets.only(top: 20.sp),
      child: CustomSwitchTile(
        title: colorMode == ColorMode.dark ? 'Dark Mode' : 'Light Mode',
        value: colorMode == ColorMode.dark,
        onChanged: (isDarkMode) {
          // Toggle the color mode
          ref.read(colorModeProvider.notifier).toggleColorMode();
        },
        activeColor: AppColorHelper.getPrimaryColor(colorMode),
        inactiveThumbColor: AppColorHelper.getPrimaryColor(colorMode),
        inactiveTrackColor: AppColors.lightScaffoldColor,
        colorMode: colorMode,
      ),
    );
  }
}

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final ColorMode colorMode;

  const CustomSwitchTile(
      {super.key,
        required this.title,
        required this.value,
        required this.onChanged,
        this.activeColor = Colors.blue,
        this.inactiveThumbColor = Colors.grey,
        this.inactiveTrackColor = Colors.grey,
        required this.colorMode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:AppColorHelper.getScaffoldColor(colorMode)),
          child: Icon(
            colorMode == ColorMode.dark ? Icons.sunny : Icons.mode_night,
            size: 15.sp,
            color: AppColorHelper.getPrimaryTextColor(colorMode),
          ),
        ),
        16.horizontalSpace,
        Text(
          title,
          style: PoppinsStyles.semiBold(
            color: AppColorHelper.getPrimaryTextColor(
              value ? ColorMode.dark : ColorMode.light,
            ),
          ).copyWith(fontSize: 14.sp),
        ),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
        ),
      ],
    );
  }
}
