import 'package:naro/services/database_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'letter_notifier.g.dart'; // 🔥 build_runner가 생성할 파일 연결

@riverpod
class LetterNotifier extends _$LetterNotifier {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return await DatabaseHelper.getAllLetters();
  }
  // WritingScreen에서 편지 추가
  Future<int> addLetter(
    Map<String, dynamic> letter,
    List<String> imagesPath
  ) async {
    final newId = await DatabaseHelper.insertLetter(letter);

    if (imagesPath.isNotEmpty) {
      await DatabaseHelper.insertImages(newId, imagesPath);
    }
    final letterWithId = {
      'id': newId,
      ...letter,
    };
    state = AsyncValue.data([
      ...(state.value ?? []),
      letterWithId,
    ]);
    return newId;
  }

  String? getLetterArrivalDate(int letterId) {
    final letters = state.value;
    if (letters == null) {
      return null;
    }
    final target = letters.firstWhere(
      (letter) => letter['id'] == letterId,
      orElse: () => {},
    );
    // print('getter ${target['arrival_at']}');
    return target['arrival_at'];
  }
  // void a() {
  //   debugPrint('test a: ${state.value}');
  // }
}