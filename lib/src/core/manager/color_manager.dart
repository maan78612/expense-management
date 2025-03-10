import 'package:expense_managment/src/core/constants/colors.dart';
import 'package:expense_managment/src/core/enums/color_mode_enum.dart';
import 'package:expense_managment/src/core/manager/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorModeNotifier extends StateNotifier<ColorMode> {
  ColorModeNotifier() : super(ColorMode.dark);

  void toggleColorMode() {
    state = state == ColorMode.light ? ColorMode.dark : ColorMode.light;
    ThemeManager().saveThemeState(state == ColorMode.dark ? true : false);
  }

  void setColorMode(ColorMode mode) {
    state = mode;
  }
}

final colorModeProvider =
    StateNotifierProvider<ColorModeNotifier, ColorMode>((ref) {
  return ColorModeNotifier();
});

class AppColorHelper {
  static Color getPrimaryColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightPrimaryColor
        : AppColors.darkPrimaryColor;
  }

  static Color getScaffoldColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightScaffoldColor
        : AppColors.darkScaffoldColor;
  }

  static Color getPrimaryTextColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.blackColor
        : AppColors.whiteColor;
  }

  static Color getSecondaryTextColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightSecondaryTextColor
        : AppColors.darkSecondaryTextColor;
  }

  static Color getIconColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightIconColor
        : AppColors.darkIconColor;
  }

  static Color cardColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightCardColor
        : AppColors.darkCardColor;
  }

  static Color borderColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.darkBorderColor
        : AppColors.borderColor;
  }

  static Color hintColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.hintColor
        : AppColors.darkSecondaryTextColor;
  }

  static Color focusedBorderColor(ColorMode mode) {
    return mode == ColorMode.light
        ? AppColors.lightFocusedBorderColor
        : AppColors.darkFocusedBorderColor;
  }
}
