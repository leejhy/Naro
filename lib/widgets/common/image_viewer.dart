import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

class ImageViewer extends StatelessWidget {
  final String imagePath;
  const ImageViewer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: 'image_viewer_opened');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // ← 기본 뒤로가기 제거
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context), // ← 닫기 동작
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
