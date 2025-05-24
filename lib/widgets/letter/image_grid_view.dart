import 'package:flutter/material.dart';
import 'package:naro/styles/colors.dart';
import 'dart:io';
import 'package:naro/widgets/common/image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';

class ImageGridView extends StatelessWidget {
  const ImageGridView({super.key, required this.imagePaths});
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('image'.tr(), style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            color: UIColors.black,
            fontWeight: FontWeight.bold,
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            children: List.generate(3, (index) {
              if (index < imagePaths.length) {
                return _buildPhotoItem(context, imagePaths[index]);
              }
              return Container();
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, String imagePath) {
    final file = File(imagePath);
    final exists = file.existsSync();
    if (!exists) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported_rounded, size: 30, color: Colors.white70),
        ),
      );
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ImageViewer(imagePath: imagePath),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.fill,
              ),
            ),
          )
        ),
      ],
    );
  }
}