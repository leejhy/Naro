import 'utils.dart';
import 'package:naro/models/letter_filter.dart';

({DateTime nextDate, int dDay})extractUpcomingLetterInfo(List<Map<String, dynamic>> letters) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final upcoming = letters
    .map((i) => DateTime.parse(i['arrival_at'] as String))
    .where((dt) => !dt.isBefore(today))
    .toList();
  upcoming.sort((a, b) => a.compareTo(b));

  final nextDate = upcoming.isNotEmpty ? upcoming.first : DateTime(1900,1,1);
  final int dDay = calculateDday(nextDate);

  return (nextDate: nextDate, dDay: dDay);
}
List<Map<String, dynamic>> filterLetters(
  List<Map<String, dynamic>> letters,
  LetterFilter filter,
) {
  final now = DateTime.now();
  return switch (filter) {
    LetterFilter.arrived =>
      letters.where((m) =>
        DateTime.parse(m['arrival_at']).isBefore(now) ||
        DateTime.parse(m['arrival_at']).isAtSameMomentAs(now)
      ).toList(),
    LetterFilter.inTransit =>
      letters.where((m) =>
        DateTime.parse(m['arrival_at']).isAfter(now)
      ).toList(),
    _ => letters
  };
}