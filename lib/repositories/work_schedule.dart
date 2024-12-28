import 'package:marine/database/database.dart';
import 'package:marine/models/work_schedule_state.dart';
import 'package:sqflite/sqflite.dart';

class WorkScheduleRepository {
  // Add your data source here, e.g., a database or API client

  WorkScheduleRepository();

  // Method to fetch all work schedules
  Future<WorkScheduleState?> getWorkSchedule() async {
    // Implement your logic to fetch work schedules
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('select * from work_schedule where id not null');

    if (maps.isNotEmpty) {
      return WorkScheduleState.fromMap(maps.first);
    }

    return null;
  }

  // Method to fetch a work schedule by ID
  Future<WorkScheduleState?> getWorkScheduleById(String id) async {
    // Implement your logic to fetch a work schedule by ID
    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query(
        'work_schedule',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return WorkScheduleState.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception("Erro ao buscar escala de trabalho, Erro: $e");
    }
  }

  // Method to create a new work schedule
  Future<void> createWorkSchedule(WorkScheduleState workSchedule) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert(
        'work_schedule',
        workSchedule.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erro ao criar escala Erro: $e');
    }
    // Implement your logic to create a new work schedule
  }

  // Method to update an existing work schedule
  Future<void> updateWorkSchedule(
      int id, WorkScheduleState workSchedule) async {
    try {
      final db = await DatabaseHelper().database;
      await db.update(
        'work_schedule',
        workSchedule.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception("Erro ao atualizar escala de trabalho. Erro: $e");
    }
  }

  // Method to delete a work schedule by ID
  Future<void> deleteWorkSchedule(String id) async {
    // Implement your logic to delete a work schedule by ID
  }
}
