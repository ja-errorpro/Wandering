import 'package:Wandering/auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_model.dart';
import 'package:Wandering/preference_data.dart';

// 使用者資料庫，更新時需要與 Firebase 上的使用者資料同步
class UserDatabaseHandler {
  static final _databaseName = "user.db"; // 資料庫文件名
  static final _databaseVersion = 1; // 資料庫版本
  static final userTable = 'user'; // 使用者數據表名

  UserDatabaseHandler._privateConstructor();
  static final UserDatabaseHandler instance =
      UserDatabaseHandler._privateConstructor();
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
          CREATE TABLE $userTable (
            uid INTEGER PRIMARY KEY,
            username TEXT,
            email TEXT,
            preferences TEXT,
            favoritePlaces TEXT
          )
          ''');
  }

  // 插入或更新使用者資料(需要與 Firebase 上的使用者資料同步)

  Future<int> insertOrUpdateUser(UserModel user, AuthModel auth) async {
    if (auth.isAuthenticated == false) {
      return 0; // 如果使用者未登入，則不進行任何操作
    }

    Database db = await instance.database;
    // 將 UserModel 對象轉換為 Map
    final Map<String, dynamic> row = user.toMap();
    row['uid'] = user.uid; // 使用者 ID

    // 嘗試更新，如果不存在則插入
    int count = await db.update(
      userTable,
      row,
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
    if (count == 0) {
      count = await db.insert(userTable, row);
    }

    // 更新 Firebase 上的使用者資料
    try {
      final userRef = FirebaseStorage.instance.ref().child(
        'users/${user.uid}.json',
      );
      await userRef.putString(user.toMap().toString());
    } catch (e) {
      print('Error updating Firebase user data: $e');
    }
    return count;
  }

  // 獲取使用者資料
  Future<UserModel?> getUser(int uid) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}
