import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/core/commons/custom_navigation.dart';
import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/enums/snackbar_status.dart';

class SnackBarUtils {
  static Future<void> show(String msg, SnackBarType type,
      {int? seconds}) async {
    await Flushbar(
      title: getErrorMsg(type),
      titleColor: Colors.white,
      message: msg,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: getTypeColor(type),
      isDismissible: false,
      duration: Duration(seconds: seconds ?? 2),
      icon: getIcon(type),
    ).show(CustomNavigation().navigatorKey.currentContext!);
  }

  static Color getTypeColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return AppColors.redColor;
      case SnackBarType.success:
        return AppColors.greenColor;
      case SnackBarType.info:
        return AppColors.lightPrimaryColor;
      default:
        return AppColors.orangeColor;
    }
  }

  static Widget getIcon(SnackBarType type) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0.r),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6.sp),
        child: Center(
          child: Icon(
            size: 18.sp,
            getTypeIcon(type),
            color: getTypeColor(type),
          ),
        ),
      ),
    );
  }

  static IconData getTypeIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.success:
        return Icons.done;
      case SnackBarType.info:
        return Icons.info;
      default:
        return Icons.warning;
    }
  }

  static String getErrorMsg(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return "Error";
      case SnackBarType.success:
        return "Success";
      case SnackBarType.info:
        return "Info";
      default:
        return "Warning";
    }
  }
}
