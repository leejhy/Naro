import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateDialog extends StatefulWidget {
  const DateDialog({super.key});
  @override
  State<DateDialog> createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  static const int _minYear = 2025;
  static const int _maxYear = 2100;

  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  int _day = DateTime.now().day;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;

  @override
  void initState() {
    super.initState();
    _yearCtrl  = FixedExtentScrollController(initialItem: _year - _minYear);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _dayCtrl   = FixedExtentScrollController(initialItem: _day - 1);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(_year, _month); // :contentReference[oaicite:1]{index=1}

    return AlertDialog(
      title: const Text('도착 날짜 선택'),
      content: SizedBox(
        width: 400,
        height: 110,
        child: Row(
          children: [
            // Year picker
            Expanded(
              child: CupertinoPicker(
                scrollController: _yearCtrl,
                itemExtent: 32,
                looping: false,                               // no infinite loop :contentReference[oaicite:2]{index=2}
                onSelectedItemChanged: (i) {
                  setState(() {
                    _year = _minYear + i;
                    // clamp day if overflow
                    if (_day > daysInMonth) _day = daysInMonth;
                    _dayCtrl.jumpToItem(_day - 1);
                  });
                },
                children: List.generate(
                  _maxYear - _minYear + 1,
                  (i) => Center(child: Text('${_minYear + i} 년', style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),)),
                ),
              ),
            ),
            // Month picker
            Expanded(
              child: CupertinoPicker(
                scrollController: _monthCtrl,
                itemExtent: 32,
                looping: false,
                onSelectedItemChanged: (i) {
                  setState(() {
                    _month = i + 1;
                    if (_day > daysInMonth) _day = daysInMonth;
                    _dayCtrl.jumpToItem(_day - 1);
                  });
                },
                children: List.generate(
                  12,
                  (i) => Center(child: Text('${i + 1} 월', style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),)),
                ),
              ),
            ),
            // Day picker
            Expanded(
              child: CupertinoPicker(
                scrollController: _dayCtrl,
                itemExtent: 32,
                looping: false,
                onSelectedItemChanged: (i) {
                  setState(() => _day = i + 1);
                },
                children: List.generate(
                  daysInMonth,
                  (i) => Center(child: Text('${i + 1} 일', style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),)),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, DateTime(_year, _month, _day)),
          child: const Text('저장'),
        ),
      ],
    );
  }
}