import 'package:marine/database/database.dart';
import 'package:marine/models/app_state.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  UserRepository();
  Future<void> setUsername(AppState user) async {
    try {
      final db = await DatabaseHelper().database;

      await db.insert(
        'user',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erro ao criar nome Erro: $e');
    }
  }
}
