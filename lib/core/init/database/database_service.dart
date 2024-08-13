import 'package:wallet_app/view/user_list/model/user_database_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late UserDatabaseProvider _userDatabaseProvider;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    _userDatabaseProvider = UserDatabaseProvider();
    _userDatabaseProvider.open();
  }

  UserDatabaseProvider get userDatabaseProvider => _userDatabaseProvider;
}
