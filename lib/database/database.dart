import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // /data/user/0/com.example.marine/databases/app.db
    String path = join(await getDatabasesPath(), 'app.db');
    // await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE events(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT, 
            allDay INTEGER, 
            startDay INTEGER, 
            endDay INTEGER,
            embarked INTEGER,
            startHour TEXT, 
            endHour TEXT, 
            color INTEGER);
            
            ''');

        await db.execute('''
            CREATE TABLE work_schedule(
            id INTEGER PRIMARY KEY,
            schedule TEXT,
            boardingDay INTEGER,
            years INTEGER,
            preBoardingMeeting INTEGER
            );
            
            ''');
      },
    );
  }
}
