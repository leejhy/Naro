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
      version: 2,
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
        await db.execute('''
          CREATE TABLE letter_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            letter_id INTEGER NOT NULL,
            path TEXT NOT NULL,
            FOREIGN KEY (letter_id) REFERENCES letters (id) ON DELETE CASCADE
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE letter_images (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              letter_id INTEGER NOT NULL,
              path TEXT NOT NULL,
              FOREIGN KEY (letter_id) REFERENCES letters (id) ON DELETE CASCADE
            );
          ''');
        }
      },
    );
  }

  static String _generateRandomUsername(int length) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    return List.generate(length, (_) => chars[_random.nextInt(chars.length)]).join();
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

  static Future<int> insertLetter(Map<String, Object?> letter) async {
    final db = await database;
    return await db.insert('letters', letter);
    //return id;
  }

  static Future<List<String>> getImagePaths(int letterId) async {
    final db = await database;
    final result = await db.query('letter_images', where: 'letter_id = ?', whereArgs: [letterId]);
    return result.map((row) => row['path'] as String).toList();
  }

  static Future<void> insertImages(int letterId, List<String> paths) async {
    if (paths.isEmpty) return;
    final db = await database;
    final batch = db.batch();
    for (final path in paths) {
      batch.insert('letter_images', {
        'letter_id': letterId,
        'path': path,
      });
    }
    await batch.commit(noResult: true);
  }
  // // 데이터 삭제 (id 기준)
  static Future<void> deleteAllLetter() async {
    final db = await database;
    await db.delete('letters');
  }
}