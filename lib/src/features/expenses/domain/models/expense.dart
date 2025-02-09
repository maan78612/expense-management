import 'package:expense_managment/src/core/constants/globals.dart';
import 'package:expense_managment/src/features/dashboard/domain/models/category.dart';

class ExpenseModel {
  final int id;
  final String title;
  final double amount;
  final CategoryModel category;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category_id': category.id, // Store only category ID
      'date': date.toIso8601String(),
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: _getCategoryById(json['category_id']),
      // Get category from ID
      date: DateTime.parse(json['date']),
    );
  }

  static CategoryModel _getCategoryById(int id) {
    // Implement your category lookup logic here
    // This could come from a separate table or predefined list
    return categories.firstWhere((c) => c.id == id);
  }
}
