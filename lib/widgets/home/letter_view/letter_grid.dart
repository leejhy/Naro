import 'package:flutter/material.dart';
import 'package:naro/widgets/home/letter_view/letter_card.dart';

class LetterGridSection extends StatefulWidget {
  final List<Map<String, dynamic>> letters;

  const LetterGridSection({
    super.key,
    required this.letters,
  });

  @override
  State<LetterGridSection> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterGridSection> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth >= 900) {
      crossAxisCount = 6;
    } else if (screenWidth >= 600) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 2;
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 10,
          childAspectRatio: 0.86,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final letter = widget.letters[index];
            return LetterCard(
              letter: letter,
            );
          },
          childCount: widget.letters.length,
        ),
      ),
    );
  }
}