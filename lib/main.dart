import 'package:flutter/material.dart';
import 'package:naro/router.dart';
import 'package:naro/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.database;
  // final dbPath = await getDatabasesPath();
  // final path = join(dbPath, 'test.db');

  // debugPrint('db 존재?');
  // debugPrint(await File(path).exists());
  runApp(
    ProviderScope(
      child:
        const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
