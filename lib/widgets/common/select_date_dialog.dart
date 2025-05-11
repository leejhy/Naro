import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateDialog extends StatefulWidget {
  const SelectDateDialog({super.key});
  @override
  State<SelectDateDialog> createState() => _DateDialogState();
}

class _DateDialogState extends State<SelectDateDialog> {
  static const int _maxYear = 2050;
  final DateTime _today = DateTime.now();

  late int _year;
  late int _month;
  late int _day;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;

  List<int> get _yearList =>
      List.generate(_maxYear - _today.year + 1, (i) => _today.year + i);
  List<int> get _monthList {
    if (_year == _today.year) {
      return List.generate(12 - _today.month + 1, (i) => _today.month + i);
    }
    return List<int>.generate(12, (i) => i + 1);
  }

  List<int> get _dayList {
    final total = DateUtils.getDaysInMonth(_year, _month);
    if (_year == _today.year && _month == _today.month) {
      return List.generate(total - _today.day + 1, (i) => _today.day + i);
    }
    return List<int>.generate(total, (i) => i + 1);
  }

  void _clampSelections() {
    if (!_monthList.contains(_month)) {
      _month = _monthList.first;
      _monthCtrl.jumpToItem(0);
    }
    if (!_dayList.contains(_day)) {
      _day = _dayList.first;
      _dayCtrl.jumpToItem(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _year  = _today.year;
    _month = _today.month;
    _day   = _today.day;

    _yearCtrl  = FixedExtentScrollController(initialItem: 0);
    _monthCtrl = FixedExtentScrollController(initialItem: 0);
    _dayCtrl   = FixedExtentScrollController(initialItem: 0);
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
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      title: const Text('도착 날짜 선택'),
      content: SizedBox(
        width: 400,
        height: 110,
        child: Row(
          children: [
            Expanded(
              child: CupertinoPicker(
                scrollController: _yearCtrl,
                itemExtent: 32,
                looping: false,
                onSelectedItemChanged: (i) {
                  setState(() {
                    _year = _yearList[i];
                    _clampSelections();
                  });
                },
                children: _yearList.map((y) => Center(
                  child: Text('$y 년', style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF444444),
                    ),
                  ),
                )).toList(),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: _monthCtrl,
                itemExtent: 32,
                looping: false,
                onSelectedItemChanged: (i) {
                  setState(() {
                    _month = _monthList[i];
                    _clampSelections();
                  });
                },
                children: _monthList.map((m) => Center(
                  child: Text('$m 월', style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF444444),
                  )),
                ))
                .toList(),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: _dayCtrl,
                itemExtent: 32,
                looping: false,
                onSelectedItemChanged: (i) {
                  setState(() => _day = _dayList[i]);
                },
                children: _dayList.map((d) => Center(
                  child: Text('$d 일', style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF444444),
                  )),
                ))
                .toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('취소', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          )),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            final formatted = DateFormat('yyyy-MM-dd').format(DateTime(_year, _month, _day));
            Navigator.pop(context, formatted);
          },
          child: const Text('저장', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          )),
        ),
      ],
    );
  }
}
