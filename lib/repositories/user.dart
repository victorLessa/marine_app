import 'package:marine/database/database.dart';
import 'package:marine/models/app_state.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  UserRepository();

  Future<AppState> getUserData() async {
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('user');

      if (maps.isNotEmpty) {
        return AppState.fromMap(maps.first);
      } else {
        return AppState();
      }
    } catch (e) {
      throw Exception('Erro ao buscar nome Erro: $e');
    }
  }

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
