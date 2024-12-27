import 'package:marine/database/database.dart';
import 'package:marine/models/event_state.dart';
import 'package:sqflite/sqflite.dart';

class EventRepository {
  Future<void> insertEvent(EventState event) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert('events', event.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception("Erro ao criar evento. Erro: $e");
    }
  }

  Future<List<EventState>> getEvents() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    List<EventState> result = List.generate(maps.length, (i) {
      return EventState.fromMap(maps[i]);
    });

    return result;
  }

  Future<List<EventState>> findByDate(DateTime date) async {
    final db = await DatabaseHelper().database;
    List<Map<String, dynamic>> maps = await db.query('events',
        where: 'startDay <= ? and endDay >= ?',
        whereArgs: [date.microsecondsSinceEpoch, date.microsecondsSinceEpoch]);
    List<EventState> result = List.generate(maps.length, (i) {
      return EventState.fromMap(maps[i]);
    });

    return result;
  }

  Future<EventState> findById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps =
        await db.query('events', where: 'id = ?', whereArgs: [id]);
    return EventState.fromMap(maps.first);
  }

  Future<EventState> updateEvent(int eventId, EventState event) async {
    try {
      final db = await DatabaseHelper().database;
      await db.update('events', event.toMap(),
          where: 'id = ?', whereArgs: [eventId]);
      return event;
    } catch (e) {
      throw Exception("Erro ao atualizar evento Erro: $e");
    }
  }

  Future<List<EventState>> findByMonth(DateTime date) async {
    final db = await DatabaseHelper().database;
    final int startMonth =
        DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    final int endMonth =
        DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;
    List<Map<String, dynamic>> maps = await db.query('events',
        where: 'startDay >= ? and endDay <= ?',
        whereArgs: [startMonth, endMonth]);

    List<EventState> result = List.generate(maps.length, (i) {
      return EventState.fromMap(maps[i]);
    });

    return result;
  }

  Future<void> deleteEvent(int id) async {
    try {
      final db = await DatabaseHelper().database;
      await db.delete('events', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception("Erro ao apagar evento. Erro: $e");
    }
  }
}
