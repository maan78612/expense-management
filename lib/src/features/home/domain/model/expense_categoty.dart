import 'package:flutter/material.dart';

class ExpenseCategory {
  final int id;

  final String name;
  final double amount;
  final Color color;
  final DateTime date;
  final IconData icon;

  ExpenseCategory(
      {required this.id,
      required this.name,
      required this.amount,
      required this.color,
      required this.date,
      required this.icon // Add date to the constructor
      });
}
