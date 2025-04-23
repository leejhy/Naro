String? calculateDday(DateTime arrivalAt) {
  DateTime now = DateTime.now();
  Duration difference = arrivalAt.difference(now);
  int dDay = difference.inDays + 1;//하루추가

  if (dDay < 0) return null;
  if (dDay == 0) return 'Day';
  return dDay.toString();
}