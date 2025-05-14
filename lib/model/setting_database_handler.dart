import 'package:sqflite/sqflite.dart';
import 'setting_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SettingDatabaseHandler {
  static final _databaseName = "settings.db"; // 資料庫文件名
  static final _databaseVersion = 1; // 資料庫版本
  static final settingsTable = 'settings'; // 設定數據表名

  SettingDatabaseHandler._privateConstructor();
  static final SettingDatabaseHandler instance =
      SettingDatabaseHandler._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化資料庫
  _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // 創建資料庫表
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $settingsTable (
            id INTEGER PRIMARY KEY,
            fontSize REAL,
            theme TEXT,
            language TEXT,
            region TEXT,
            currency TEXT,
            timeZone TEXT
          )
          ''');
  }

  // 插入或更新用戶設定
  Future<int> insertOrUpdateSettings(SettingModel settings) async {
    Database db = await instance.database;
    // 將 SettingModel 對象轉換為 Map
    final Map<String, dynamic> row = settings.toMap();
    row['id'] = 1; // 我們假設只有一條用戶設定數據，id 為 1

    // 嘗試更新，如果不存在則插入
    int count = await db.update(
      settingsTable,
      row,
      where: 'id = ?',
      whereArgs: [1],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return count;
  }

  // 獲取用戶設定
  Future<SettingModel?> getSettings() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(settingsTable);

    if (maps.isNotEmpty) {
      return SettingModel.fromMap(maps.first);
    }
    return null;
  }
}
