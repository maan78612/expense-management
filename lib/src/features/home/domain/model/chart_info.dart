import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';

class ChartInfoModel {
  final double amount;
  final CategoryModel category;

  ChartInfoModel({
    required this.amount,
    required this.category,
  });
}
