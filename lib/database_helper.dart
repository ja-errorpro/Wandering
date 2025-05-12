import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import './preference_data.dart'; // 確保 UserPreferences 類別在這裡可以訪問

class DatabaseHelper {
  static final _databaseName = "preferences.db"; // 資料庫文件名
  static final _databaseVersion = 1; // 資料庫版本
  static final preferencesTable = 'user_preferences'; // 偏好數據表名

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化資料庫
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // 創建資料庫表
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $preferencesTable (
            id INTEGER PRIMARY KEY,
            travelStyles TEXT,
            locationTypes TEXT,
            accommodationTypes TEXT,
            avoidTypes TEXT
          )
          ''');
  }

  // 插入或更新用戶偏好
  Future<int> insertOrUpdatePreferences(UserPreferences preferences) async {
    Database db = await instance.database;
    // 將 UserPreferences 對象轉換為 Map
    final Map<String, dynamic> row = preferences.toMap();
    row['id'] = 1; // 我們假設只有一條用戶偏好數據，id 為 1

    // 嘗試更新，如果不存在則插入
    int count = await db.update(
        preferencesTable, row,
        where: 'id = ?', whereArgs: [1]);

    if (count == 0) {
      // 如果沒有更新（表示id為1的記錄不存在），則插入新記錄
      count = await db.insert(preferencesTable, row, conflictAlgorithm: ConflictAlgorithm.replace);
      print('用戶偏好已插入到資料庫。');
    } else {
      print('用戶偏好已更新到資料庫。');
    }
    return count;
  }

  // 獲取用戶偏好
  Future<UserPreferences?> getPreferences() async {
    Database db = await instance.database;
    List<Map> maps = await db.query(preferencesTable,
        columns: ['id', 'travelStyles', 'locationTypes', 'accommodationTypes', 'avoidTypes'],
        where: 'id = ?',
        whereArgs: [1]);

    if (maps.isNotEmpty) {
      // 從資料庫行創建 UserPreferences 對象
      final Map<String, dynamic> map = Map<String, dynamic>.from(maps.first);
      return UserPreferences.fromMap(map); // 使用 fromMap 方法
    } else {
      return null; // 資料庫中沒有用戶偏好數據
    }
  }

  // 刪除用戶偏好 (可選)
  Future<int> deletePreferences() async {
    Database db = await instance.database;
    return await db.delete(preferencesTable, where: 'id = ?', whereArgs: [1]);
  }
}
