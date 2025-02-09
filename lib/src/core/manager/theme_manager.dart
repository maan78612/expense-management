import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await createDatabase();
    return _database!;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Database> createDatabase() async {
    String path = join(await _localPath, 'theme.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE theme (
          isDarkMode INTEGER
        )
      ''');
    });
  }

  Future<void> saveThemeState(bool isDarkMode) async {
    final db = await database;
    await db.delete('theme');
    await db.insert('theme', {'isDarkMode': isDarkMode ? 1 : 0});
    debugPrint("saveThemeState is dark = $isDarkMode");
  }

  Future<bool> getThemeState() async {
    final db = await database;
    final maps = await db.query('theme');
    debugPrint("maps = $maps");
    if (maps.isEmpty) return true;
    return maps[0]['isDarkMode'] == 1;
  }
}
