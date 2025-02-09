import 'package:expense_managment/src/features/expenses/domain/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpenseDataSourceLocal {
  static final ExpenseDataSourceLocal _instance =
      ExpenseDataSourceLocal._internal();

  factory ExpenseDataSourceLocal() => _instance;

  ExpenseDataSourceLocal._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            title TEXT,
            amount REAL,
            category_id INTEGER,
            date TEXT
          )
        ''');
    });
  }

  Future<void> saveExpense(String email, ExpenseModel expense) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> existingExpenses =
          await db.query('expenses', where: 'email = ?', whereArgs: [email]);
      final List<ExpenseModel> expenses =
          existingExpenses.map((e) => ExpenseModel.fromJson(e)).toList();
      expenses.add(expense);
      await db.delete('expenses', where: 'email = ?', whereArgs: [email]);
      for (var e in expenses) {
        await db.insert('expenses', {...e.toJson(), 'email': email});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getExpenses(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('expenses', where: 'email = ?', whereArgs: [email]);

      return List.generate(maps.length, (i) {
        return ExpenseModel.fromJson(maps[i]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateExpense(String email, ExpenseModel expense) async {
    try {
      debugPrint("expense model = ${expense.toJson()}");
      final db = await database;
      debugPrint('Updating expense with id: ${expense.id}');
      await db.update('expenses', {...expense.toJson(), 'email': email},
          where: 'id = ?', whereArgs: [expense.id]);
      debugPrint('Expense updated successfully');
    } catch (e) {
      debugPrint('Error updating expense: $e');
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      final db = await database;
      await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }
}
