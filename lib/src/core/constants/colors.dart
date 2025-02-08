import 'package:flutter/material.dart';

class AppColors {
  // Common colors used across both themes
  static const Color lightPrimaryColor = Color(
      0xffffcd3c); // Main primary color (yellow), used for buttons, highlights
  static const Color redColor = Color(
      0xfff83744); // Error or alert color (red), used for error messages, warnings
  static const Color orangeColor = Color(
      0xffF38744); // Secondary accent color (orange), used for secondary buttons or accents
  static const Color greenColor = Color(
      0xff08A765); // Success color (green), used for success messages, confirmations
  static const Color greyColor = Color(
      0xff828282); // Neutral grey, used for borders or text that’s less emphasized
  static const Color whiteColor =
      Colors.white; // Pure white color, commonly used for backgrounds or text
  static const Color blackColor = Colors.black;
  static Color lightFocusedBorderColor = lightPrimaryColor.withOpacity(
      .65); // Focused input field border color (yellow with opacity)

  // Light theme colors
  static const Color lightSecondaryTextColor =
      Color(0xff344054); // Dark grey for secondary text (less important text)
  static const Color borderColor = Color(
      0xffEEEEEE); // Light grey border color, used for inputs, cards, or section dividers
  static const Color hintColor = Color(
      0xffcfd1d7); // Hint text color, used for placeholders in input fields
  static const Color whiteBg = Color(
      0xffFAFAFC); // Background color for light theme, used for overall background
  static const Color lightScaffoldColor = Colors
      .white; // Scaffold background color for light theme, typically white
  static const Color lightCardColor = Color(0xffFFFCF1);
  static const Color lightIconColor = Color(0xff1F2937);

  // Dark theme colors
  static const Color darkSecondaryTextColor =
      Color(0xffA7B0C2); // Lighter grey for secondary text in dark theme
  static const Color darkBorderColor = Color(
      0xff444950); // Dark grey border color, used for inputs, cards, or section dividers
  static const Color darkHintColor =
      Color(0xff636c72); // Lighter grey for hint text in dark theme
  static const Color darkWhiteBg =
      Color(0xff121212); // Dark background color for dark theme, deep grey
  static const Color darkScaffoldColor =
      Color(0xff121212); // Scaffold background color for dark theme, deep grey
  static Color darkFocusedBorderColor = darkPrimaryColor.withOpacity(
      .75); // Focused input field border color for dark theme (yellow with opacity)
  static const Color darkCardColor = Color(
      0xff1F2A28); // Dark green background color for cards or sections in the dark theme
  static const Color darkIconColor = Color(0xffffffff);
  static const Color darkPrimaryColor = Color(0xffFFCD3C);
}
