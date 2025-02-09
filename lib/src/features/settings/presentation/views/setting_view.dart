import 'package:expense_managment/src/core/commons/common_app_bar.dart';
import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/commons/loader.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/images.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:expense_managment/src/features/auth/presentation/views/login_view.dart';
import 'package:expense_managment/src/features/settings/presentation/viewmodels/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'components/theme_switcher.dart';

class SettingView extends ConsumerWidget {
  SettingView({super.key});

  final radius = 120.sp;
  final settingViewModelProvider =
      ChangeNotifierProvider<SettingViewModel>((ref) {
    return SettingViewModel();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingViewModel = ref.watch(settingViewModelProvider);
    final colorMode = ref.watch(colorModeProvider);

    return CustomLoader(
      isLoading: settingViewModel.isLoading,
      child: Scaffold(
        backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
        appBar: CommonAppBar(title: "Settings", colorMode: colorMode),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: radius / 2),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _cardWidget(colorMode, context, settingViewModel),
                Positioned(
                  top: -(radius / 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000.sp),
                    child: Container(
                      width: radius,
                      height: radius,
                      color: AppColorHelper.getIconColor(colorMode),
                      child: Icon(
                        Icons.person,
                        size: radius / 1.5,
                        color: AppColorHelper.getScaffoldColor(colorMode),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardWidget(ColorMode colorMode, BuildContext context,
      SettingViewModel settingViewModel) {
    return Card(
      elevation: 5,
      color: AppColorHelper.cardColor(colorMode),
      margin: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 50.sp),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (radius / 2).verticalSpace,
            _tiles(
                img: AppImages.person,
                title: "My Profile",
                onTap: () async {},
                colorMode: colorMode),
            _tiles(
                img: AppImages.faq,
                title: "Helps & FAQ's",
                onTap: () {},
                colorMode: colorMode),

            _ThemeSwitcher(),
            _tiles(
                img: AppImages.deleteUser,
                title: 'Delete Account',
                onTap: () {
                  _showDeleteDialog(context, colorMode);
                },
                colorMode: colorMode),
            const Spacer(),
            _tiles(
                img: AppImages.logout,
                title: "Log Out",
                onTap: () {
                  _showLogoutDialog(context, colorMode, settingViewModel);
                },
                colorMode: colorMode),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _tiles(
      {required String img,
      required String title,
      required Function onTap,
      required ColorMode colorMode}) {
    return Padding(
      padding: EdgeInsets.only(top: 20.sp),
      child: CommonInkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorHelper.getScaffoldColor(colorMode)),
              child: Image.asset(
                img,
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.contain,
                color: AppColorHelper.getPrimaryTextColor(colorMode),
              ),
            ),
            16.horizontalSpace,
            Text(
              title,
              style: PoppinsStyles.medium(
                      color: AppColorHelper.getPrimaryTextColor(colorMode))
                  .copyWith(fontSize: 16.sp),
            ),
            const Spacer(),
            Icon(Icons.chevron_right,
                color: AppColorHelper.getIconColor(colorMode), size: 30.sp)
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ColorMode colorMode,
      SettingViewModel settingViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
          title: Text(
            'Logout',
            style: PoppinsStyles.semiBold(
                    color: AppColorHelper.getPrimaryTextColor(colorMode))
                .copyWith(fontSize: 16.sp),
          ),
          content: Text('Are you sure you want to log out?',
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
              child: Text('Logout',
                  style: PoppinsStyles.medium(color: AppColors.redColor)
                      .copyWith(fontSize: 14.sp)),
              onPressed: () {
                settingViewModel.signOut(onSuccess: () {
                  CustomNavigation().pushAndRemoveUntil(LoginView());
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ColorMode colorMode) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColorHelper.getScaffoldColor(colorMode),
          title: Text(
            'Delete Permanently',
            style: PoppinsStyles.semiBold(
                    color: AppColorHelper.getPrimaryTextColor(colorMode))
                .copyWith(fontSize: 16.sp),
          ),
          content: Text('Are you sure you want to delete your account?',
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
              child: Text('delete',
                  style: PoppinsStyles.medium(color: AppColors.redColor)
                      .copyWith(fontSize: 14.sp)),
              onPressed: () {
                // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
