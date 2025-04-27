// lib/features/letters/letter_notifier.dart
import 'package:flutter/material.dart';
import 'package:naro/services/database_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'letter_notifier.g.dart'; // 🔥 build_runner가 생성할 파일 연결

@riverpod
class LetterNotifier extends _$LetterNotifier {
  @override
  Future<List<Map<String, dynamic>>> build() {
    return DatabaseHelper.getAllLetters();
  }

  // WritingScreen에서 편지 추가
  Future<void> addLetter(Map<String, dynamic> letter) async {
    await DatabaseHelper.insertLetter(letter);
    state = AsyncValue.data([
      ...(state.value ?? []),
      letter,
    ]);
  }
  void a() {
    debugPrint('${state.value}');
  }
}