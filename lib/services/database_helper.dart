import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class DatabaseHelper {
  static Database? _db;
  static final Random _random = Random();

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
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // DB 처음 생성될 때 실행됨
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            user_name TEXT NOT NULL
          );
        ''');
        await db.insert('users', {
          'user_name': _generateRandomUsername(16),
        });
        await db.execute('''
          CREATE TABLE letters (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            arrival_at TEXT NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
          );
        ''');
      },
    );
  }

  static String _generateRandomUsername(int length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    return List.generate(length, (_) => chars[_random.nextInt(chars.length)]).join();
  }

  static Future<int> getUserId() async {
    return 1;
    // final db = await database;

    // final result = await db.query('users',
    //   columns: ['id'],
    //   limit: 1,
    // );

    // return result.first['id'] as int;
  }
  static Future<String> getUserName() async {
    final db = await database;
    final result = await db.query('users', columns: ['user_name']);
    if (result.isEmpty) {
      throw Exception('No user found');
    }
    final username = result[0]['user_name'] as String;
    return username;
  }
  // 모든 letters 조회
  static Future<List<Map<String, Object?>>> getAllLetters() async {
    final db = await database;
    return await db.query('letters');
  }
  static Future<List<Map<String, Object?>>> getLetter(int id) async {
    final db = await database;
    return await db.query('letters', where: 'id = ?', whereArgs: [id]);
  }

  // note 추가
  // void testfunction() async {
  //   final int user_id = await DatabaseHelper.getUserId();
  // final letter = {
      // user_id': user_id,  // 전달받은 user_id
    //   'title': 'example title',
    //   'content': 'example content',
    //   'arrival_at': DateTime.now().add(Duration(days: 30)).toIso8601String(),
    //   'created_at': DateTime.now().toIso8601String(),
    // }
    // await DatabaseHelper.insertLetter(letter);
  //  };
  static Future<int> insertLetter(Map<String, Object?> letter) async {
    final db = await database;
    return await db.insert('letters', letter);
    //return id;
  }

  // // 데이터 삭제 (id 기준)
  static Future<void> deleteAllLetter() async {
    final db = await database;
    await db.delete('letters');
  }
}