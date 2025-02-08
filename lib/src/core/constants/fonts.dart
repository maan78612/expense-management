import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoppinsStyles {
  static const double fontSize = 14.0;

  static TextStyle thin({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w100,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );

  static TextStyle extraLight({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w200,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );

  static TextStyle light({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );

  static TextStyle regular({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1,
    color: color,
  );

  static TextStyle medium({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: fontSize.sp,
    height: 1.sp,
    color: color,
  );

  static TextStyle semiBold({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1,
    color: color,
  );

  static TextStyle bold({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );

  static TextStyle extraBold({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w800,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );

  static TextStyle black({required Color color}) => TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
    fontSize: fontSize.sp,
    height: 1,
    color: color,
  );
}
