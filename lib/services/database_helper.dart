// lib/services/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  // DB 인스턴스를 반환하는 getter
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // DB 초기화: 새로 생성
  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath(); // 앱 전용 SQLite 저장 위치
    final path = join(dbPath, 'test.db'); // 'test.db' 라는 이름으로 저장

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // DB 처음 생성될 때 실행됨
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  // 데이터 전체 조회
  static Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  // 데이터 삽입
  static Future<void> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert('notes', note);
  }

  // 데이터 삭제 (id 기준)
  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // 데이터 업데이트 (id 기준)
  static Future<void> updateNote(int id, Map<String, dynamic> updatedNote) async {
    final db = await database;
    await db.update('notes', updatedNote, where: 'id = ?', whereArgs: [id]);
  }
}
