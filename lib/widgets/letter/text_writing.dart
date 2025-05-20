import 'package:flutter/material.dart';

class TextWriting extends StatelessWidget {
  final String title;
  final String content;
  const TextWriting({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 10),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}