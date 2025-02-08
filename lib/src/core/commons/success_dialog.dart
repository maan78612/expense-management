import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/core/commons/custom_button.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';

class SuccessDialog extends StatelessWidget {
  final String heading;
  final String text;
  final String img;
  final ColorMode colorMode;

  const SuccessDialog(
      {super.key,
      required this.text,
      required this.heading,
      required this.colorMode,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.85.sw,
      padding: EdgeInsets.all(12.sp), // Add padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fit to content
        children: [
          24.verticalSpace,
          SizedBox(width: 130.sp, height: 130.sp, child: Image.asset(img)),
          24.verticalSpace,
          Center(
            child: Text(
              heading,
              style: PoppinsStyles.semiBold(
                color: AppColorHelper.getPrimaryTextColor(colorMode),
              ).copyWith(
                fontSize: 18.sp,
              ),
            ),
          ),
          20.verticalSpace,
          Text(
            text,
            textAlign: TextAlign.center,
            style: PoppinsStyles.regular(
                    color: AppColorHelper.getPrimaryTextColor(colorMode))
                .copyWith(
              fontSize: 13.sp,
            ),
          ),
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    height: 37.h,
                    bgColor: AppColorHelper.getPrimaryColor(colorMode),
                    textColor: AppColors.whiteColor,
                    textStyle: PoppinsStyles.medium(
                      color: AppColors.whiteColor,
                    ).copyWith(fontSize: 14.sp),
                    title: "Done",
                    onPressed: () {
                      CustomNavigation().pop();
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
