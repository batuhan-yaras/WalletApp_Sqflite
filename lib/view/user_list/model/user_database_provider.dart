import 'package:sqflite/sqflite.dart';
import 'package:wallet_app/view/user_list/model/user_model.dart';

class UserDatabaseProvider {
  final String _userPath = "user";
  final String _userTableName = "users";
  final int _version = 2;

  final String _transferTableName = "transfers";
  String transferId = "transfer_id";
  String senderId = "senderId";
  String receiverId = "receiverId";
  String transferAmount = "amount";
  String transferDate = "transferDate";

  Database? database;

  String columnUsername = "username";
  String columnPassword = "password";
  String columnEmail = "email";
  String columnId = "id";
  String columnMoney = "money";

  Future<void> open() async {
    database = await openDatabase(
      _userPath,
      version: _version,
      onCreate: (db, version) {
        createTable(db);
        createTransferTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          // Veritabanı şemasını güncelle
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

  Future<UserModel?> getItem(int id) async {
    final db = await getDatabase();
    final userMaps = await db.query(
      _userTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (userMaps.isNotEmpty) {
      return UserModel.fromJson(userMaps.first);
    } else {
      return null;
    }
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

  Future<void> createTransferTable(Database db) async {
    await db.execute(
      '''CREATE TABLE $_transferTableName (
          $transferId INTEGER PRIMARY KEY AUTOINCREMENT,
          $senderId INTEGER,
          $receiverId INTEGER,
          $transferAmount REAL,
          $transferDate TEXT,
          FOREIGN KEY($senderId) REFERENCES users(id),
          FOREIGN KEY($receiverId) REFERENCES users(id)
          )''',
    );
  }

  Future<void> transferMoney(int senderId, int receiverId, double amount) async {
    final db = await getDatabase();

    await db.transaction((txn) async {
      // Sender'ın bakiyesini güncelle
      await txn.rawUpdate(
        'UPDATE $_userTableName SET $columnMoney = $columnMoney - ? WHERE $columnId = ?',
        [amount, senderId],
      );

      // Receiver'ın bakiyesini güncelle
      await txn.rawUpdate(
        'UPDATE $_userTableName SET $columnMoney = $columnMoney + ? WHERE $columnId = ?',
        [amount, receiverId],
      );
/*
      // Transfer detaylarını ekle
      await txn.rawInsert(
        'INSERT INTO $_transferTableName ($transferId, $senderId, $receiverId, $transferAmount, $transferDate) VALUES (?,?,?,?,?)',
        [null, senderId, receiverId, amount, DateTime.now().toIso8601String()],
      );
      */
    });
  }

  Future<void> updateMoney(double farmAmount, int senderId) async {
    final db = await getDatabase();
    await db.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE $_userTableName SET $columnMoney = $columnMoney + ? WHERE $columnId = ?',
        [farmAmount, senderId],
      );
    });
  }
}
