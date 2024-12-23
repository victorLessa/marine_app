import 'package:marine/database/database.dart';
import 'package:marine/models/event_state.dart';
import 'package:sqflite/sqflite.dart';

class EventRepository {
  Future<void> insertEvent(EventState event) async {
    final db = await DatabaseHelper().database;
    await db.insert('events', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EventState>> getEvents() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('events');
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
    final db = await DatabaseHelper().database;
    await db
        .update('events', event.toMap(), where: 'id = ?', whereArgs: [eventId]);
    return event;
  }

  Future<void> deleteEvent(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
