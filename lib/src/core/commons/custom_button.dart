import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/core/commons/custom_inkwell.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/constants/fonts.dart';
import 'package:expense_managment/src/core/constants/globals.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final bool isEnable;
  final Function() onPressed;
  final Widget? icon;
  final Color bgColor;
  final Color? disableBgColor;
  final Color textColor;
  final Color loadingColor;
  final bool isLoading;
  final double loadingSize;
  final Color? borderColor;
  final double? height;
  final double? fontSize;
  final TextStyle? textStyle;

  const CustomButton(
      {super.key,
      this.title,
      required this.bgColor,
      this.disableBgColor,
      this.height,
      this.icon,
      this.fontSize,
      this.textStyle,
      this.isEnable = true,
      this.loadingColor = AppColors.whiteColor,
      this.isLoading = false,
      this.loadingSize = 25.0,
      this.textColor = AppColors.whiteColor,
      required this.onPressed,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return CommonInkWell(
      onTap: isEnable ? onPressed : null,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: height ?? inputFieldHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: isEnable ? Border.all(color: borderColor ?? bgColor) : null,
            borderRadius: BorderRadius.circular(8.r),
            color: (disableBgColor == null)
                ? bgColor.withOpacity(isEnable ? 1 : 0.5)
                : isEnable
                    ? bgColor
                    : disableBgColor),
        child: isLoading
            ? Container(
                height: loadingSize,
                width: loadingSize,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null && title != null) 8.horizontalSpace,
                  if (title != null)
                    Text(title!,
                        textAlign: TextAlign.center,
                        style:
                        PoppinsStyles.semiBold(color:  textColor)),
                ],
              ),
      ),
    );
  }
}
