
import 'package:flutter/material.dart';
import 'package:naro/controllers/image_upload_controller.dart';
import 'package:naro/widgets/writing/writing_section.dart';
import 'package:naro/widgets/common/image_upload.dart';

class WritingBody extends StatelessWidget {
  const WritingBody({
      required this.titleController,
      required this.contentController,
      required this.imageController,
      super.key
    });
  final TextEditingController titleController;
  final TextEditingController contentController;
  final ImageUploadController imageController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WritingSection(
            titleController: titleController,
            contentController: contentController,
          ),
          ImageUpload(
            imageController: imageController,
          ),
          const SizedBox(height: 40),
        ],
      )
    );
  }
}