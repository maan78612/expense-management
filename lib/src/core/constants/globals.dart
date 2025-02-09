import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';
import 'package:flutter/material.dart';
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

final List<CategoryModel> categories = [
  CategoryModel(
    id: 1,
    name: 'Food',
    icon: Icons.fastfood,
    color: Colors.red,
  ),
  CategoryModel(
    id: 2,
    name: 'Transport',
    icon: Icons.motorcycle,
    color: Colors.blue,
  ),
  CategoryModel(
    id: 3,
    name: 'Entertainment',
    icon: Icons.movie_filter_sharp,
    color: Colors.green,
  ),
  CategoryModel(
    id: 4,
    name: 'Utilities',
    icon: Icons.category,
    color: Colors.orange,
  ),
  CategoryModel(
    id: 5,
    name: 'Traveling',
    icon: Icons.travel_explore,
    color: Colors.purple,
  ),
  CategoryModel(
    id: 6,
    name: 'Others',
    icon: Icons.add_chart_sharp,
    color: Colors.grey,
  ),
];


