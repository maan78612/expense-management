import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense_managment/src/features/auth/domain/models/user_model.dart';

const int routingDuration = 300;
double inputFieldHeight = 50.sp;
double hMargin = 24.sp;
String? fcmToken;

/// Create StateNotifierProvider for user to change it's state when data change locally
final userModelProvider =
    StateNotifierProvider<UserModelProvider, UserModel>((ref) {
  return UserModelProvider();
});
