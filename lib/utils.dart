int calculateDday(DateTime arrivalAt) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  Duration difference = arrivalAt.difference(today);
  int dDay = difference.inDays;//하루추가

  return dDay;
}