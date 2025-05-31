import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:intl/intl.dart';

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
  bool get _isKorean => context.locale.languageCode == 'ko';

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
  static const _itemStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFF444444),
  );

  static const _btnStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF444444),
  );

  Widget _buildPicker(
    FixedExtentScrollController ctrl,
    List<int> items, {
    String? suffixKey,            // null이면 suffix 없음
    required ValueChanged<int> onChanged,
    String Function(int)? label,  // label 커스터마이징(영문 월)
  }) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: ctrl,
        itemExtent: 32,
        looping: false,
        onSelectedItemChanged: onChanged,
        children: items
            .map((v) => Center(
                  child: Text(
                    label != null
                        ? label(v)
                        : suffixKey == null
                            ? '$v'
                            : '$v ${suffixKey.tr()}',
                    style: _itemStyle,
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ---------- 피커 순서 ----------
  List<Widget> get _pickers {
    // 연도
    final yearPicker = _buildPicker(
      _yearCtrl,
      _yearList,
      suffixKey: _isKorean ? 'year' : null,
      onChanged: (i) {
        setState(() {
          _year = _yearList[i];
          _clampSelections();
        });
      },
    );

    // 월
    final monthPicker = _buildPicker(
      _monthCtrl,
      _monthList,
      suffixKey: _isKorean ? 'month' : null,
      label: _isKorean
          ? null
          : (m) => DateFormat('MMM', 'en').format(DateTime(0, m)), // Jan, Feb …
      onChanged: (i) {
        setState(() {
          _month = _monthList[i];
          _clampSelections();
        });
      },
    );

    // 일
    final dayPicker = _buildPicker(
      _dayCtrl,
      _dayList,
      suffixKey: _isKorean ? 'day' : null,
      onChanged: (i) => setState(() => _day = _dayList[i]),
    );

    return _isKorean
        ? [yearPicker, monthPicker, dayPicker]
        : [monthPicker, dayPicker, yearPicker];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 240, 250, 255),
      title: Text('writing.select_date'.tr()),
      content: SizedBox(
        width: 400,
        height: 110,
        child: Row(children: _pickers),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr(), style: _btnStyle),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE0EDF4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            final formatted = DateFormat('yyyy-MM-dd').format(
              DateTime(_year, _month, _day),
            );
            Navigator.pop(context, formatted);
          },
          child: Text('save'.tr(), style: _btnStyle),
        ),
      ],
    );
  }
}
