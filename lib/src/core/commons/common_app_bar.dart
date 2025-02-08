import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onTap;
  final PreferredSizeWidget? bottom;
  final ColorMode colorMode;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.colorMode,
    this.bottom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      leading: onTap != null
          ? CommonInkWell(
              onTap: () {
                onTap!();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.sp),
                child:
                    const Icon(Icons.arrow_back, color: AppColors.blackColor),
              ),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        style: PoppinsStyles.medium(
                color: AppColorHelper.getPrimaryTextColor(colorMode))
            .copyWith(fontSize: 20.sp),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
