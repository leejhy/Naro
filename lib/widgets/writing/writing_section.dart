import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naro/widgets/writing/text_field.dart';

class WritingSection extends StatefulWidget {
  const WritingSection({
    required this.titleController,
    required this.contentController,
    super.key
    });
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  State<WritingSection> createState() => _TextWritingState();
}

class _TextWritingState extends State<WritingSection> {
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  @override
  void dispose() {
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _toggleFocus(FocusNode node) {
    if (node.hasFocus) {
      node.unfocus();
    } else {
      node.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WritingTextField(
              controller: widget.titleController,
              focusNode: _titleFocus,
              maxLength: 40,
              onTap: () {},
              fontSize: 22,
              fontWeight: FontWeight.w700,
              hintText: 'writing.title_hint'.tr(),
              hintTextWeight: FontWeight.w700,
            ),
            SizedBox(
              height: 400,
              child: WritingTextField(
                controller: widget.contentController,
                focusNode: _contentFocus,
                maxLength: 2000,
                onTap: () => _toggleFocus(_contentFocus),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                hintText: 'writing.content_hint'.tr(),
                hintTextWeight: FontWeight.w400,
                expands: true,
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),
          ],
        ),
    );
  }
}