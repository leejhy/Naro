import 'package:flutter/material.dart';
import 'package:naro/models/letter_filter.dart';
import 'package:naro/styles/colors.dart';

class LetterSortingButtons extends StatelessWidget {
  const LetterSortingButtons({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final LetterFilter current;
  final ValueChanged<LetterFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SortingButton(
            label: '전체',
            selected: current == LetterFilter.all,
            onTap: () => onChanged(LetterFilter.all),
          ),
          const SizedBox(width: 8),
          SortingButton(
            label: '도착',
            selected: current == LetterFilter.arrived,
            onTap: () => onChanged(LetterFilter.arrived),
          ),
          const SizedBox(width: 8),
          SortingButton(
            label: '배송중',
            selected: current == LetterFilter.inTransit,
            onTap: () => onChanged(LetterFilter.inTransit),
          ),
        ],
      ),
    );
  }
}

class SortingButton extends StatelessWidget {
  const SortingButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        overlayColor: Color(0xFF00B6FF),
        minimumSize: const Size(4, 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: selected ? UIColors.black : UIColors.white,
        side: BorderSide(
          color: selected ? UIColors.black : Color.fromRGBO(191, 191, 191, 0.5),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? UIColors.white : UIColors.black,
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}