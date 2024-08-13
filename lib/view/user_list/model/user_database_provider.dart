import 'package:sqflite/sqflite.dart';
import 'package:wallet_app/view/user_list/model/user_model.dart';

class UserDatabaseProvider {
  final String _userPath = "user";
  final String _userTableName = "users";
  final int _version = 1;
  Database? database;

  String columnUsername = "username";
  String columnPassword = "password";
  String columnEmail = "email";
  String columnId = "id";
  String columnMoney = 'money';

  Future<void> open() async {
    database = await openDatabase(
      _userPath,
      version: _version,
      onCreate: (db, version) {
        createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute(
            '''ALTER TABLE $_userTableName ADD COLUMN $columnMoney REAL DEFAULT 100.0''',
          );
        }
      },
    );
  }

  Future<Database> getDatabase() async {
    if (database == null) {
      await open();
    }
    return database!;
  }

  Future<void> createTable(Database db) async {
    await getDatabase();

    await db.execute(
      '''CREATE TABLE $_userTableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnUsername TEXT UNIQUE,
          $columnPassword INTEGER,
          $columnEmail STRING UNIQUE,
          $columnMoney REAL DEFAULT 100.0)
          ''',
    );
  }

  Future<List<UserModel>> getList() async {
    await getDatabase();
    List<Map<String, dynamic>> userMaps = await database!.query(_userTableName);

    return userMaps.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<bool?> delete(int id) async {
    await getDatabase();
    final userMaps = await database?.delete(
      _userTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    return userMaps != null;
  }

  Future<bool?> update(int id, UserModel model) async {
    await getDatabase();
    final userMaps = await database?.update(
      _userTableName,
      model.toJson(),
      where: '$columnId = ?',
      whereArgs: [id],
    );

    return userMaps != null;
  }

  Future<void> close() async {
    await getDatabase();
    await database?.close();
  }

// Insert
  Future<bool> insert(UserModel model) async {
    await getDatabase();
    model.money ??= 100.0;
    final userMaps = await database?.insert(_userTableName, model.toJson());
    return userMaps != null;
  }

  Future<bool> isUsernameTaken(String username) async {
    await getDatabase();
    final userMaps = await database!.query(
      _userTableName,
      where: 'username = ?',
      whereArgs: [username],
    );
    return userMaps.isNotEmpty;
  }

  Future<bool> isEmailTaken(String email) async {
    await getDatabase();

    final userMaps = await database!.query(
      _userTableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    return userMaps.isNotEmpty;
  }

  Future<UserModel?> getUserByCredentials(String username, int password) async {
    await getDatabase();

    final userMaps = await database!.query(
      _userTableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (userMaps.isNotEmpty) {
      return UserModel.fromJson(userMaps.first);
    } else {
      return null;
    }
  }
}
