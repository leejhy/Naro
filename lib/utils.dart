int calculateDday(DateTime arrivalAt) {
  DateTime now = DateTime.now();
  Duration difference = arrivalAt.difference(now) + Duration(days: 1);
  int dDay = difference.inDays;//하루추가

  if (arrivalAt == DateTime(1900)) {
    print('no date');
    return -1;
  }
  return dDay;
  // if (dDay < 0) return null;
  // if (dDay == 0) return 'Day';
  // return dDay.toString();
}