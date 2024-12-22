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
    try {
      List<EventState> result = List.generate(maps.length, (i) {
        return EventState.fromMap(maps[i]);
      });

      return result;
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<void> deleteEvent(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
