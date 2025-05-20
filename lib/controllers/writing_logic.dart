import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:naro/services/firebase_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:naro/services/letter_notifier.dart';
import 'package:naro/controllers/image_upload_controller.dart';
import 'package:naro/services/database_helper.dart';
import 'package:naro/widgets/common/select_date_dialog.dart';

class WritingLogic {
  final WidgetRef ref;
  late final FirebaseAnalytics analytics;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController arrivalDateController = TextEditingController();
  final FocusNode blankFocus = FocusNode();
  final ImageUploadController imageController = ImageUploadController();

  bool dialogShown = false;

  WritingLogic(this.ref) {
    analytics = ref.read(firebaseAnalyticsProvider);
  }

  void dispose() {
    titleController.dispose();
    contentController.dispose();
    arrivalDateController.dispose();
    blankFocus.dispose();
  }

  void showDateDialog(BuildContext context, {bool initial = false}) {
    final navigator = Navigator.of(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Center(child: SelectDateDialog());
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        arrivalDateController.text = pickedDate.toString();
      } else if (initial) {
        navigator.pop();
      }
    });
  }

  Future<String> saveImageToLocal(XFile image, int idx) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'Naro_${DateTime.now().millisecondsSinceEpoch}_$idx';
    await File(image.path).copy('${appDir.path}/$fileName.jpg');
    return '$fileName.jpg';
  }

  Future<int> insertLetter() async {
    final images = imageController.images;
    final savedPaths = await Future.wait(
      images.asMap().entries.map((entry) {
        final idx = entry.key;
        final img = entry.value;
        return saveImageToLocal(img, idx);
      }).toList(),
    );

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final letter = {
      'user_id': 1,
      'title': titleController.text,
      'content': contentController.text,
      'arrival_at': arrivalDateController.text,
      'created_at': now,
    };

    final id = await ref.read(letterNotifierProvider.notifier).addLetter(letter, savedPaths);
    final username = await DatabaseHelper.getUserName();

    analytics.logEvent(name: 'writing_confirm', parameters: {
      'username': username,
      'letter_id': id,
    });

    return id;
  }
}
