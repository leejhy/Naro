import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naro/controllers/image_upload_controller.dart';
import 'package:naro/widgets/common/image_viewer.dart';

class ImageUpload extends StatefulWidget {
  final ImageUploadController imageController;
  const ImageUpload({super.key, required this.imageController});

  @override
  State<ImageUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<ImageUpload> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Text('사진', style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
            children: List.generate(3, (index) {
              if (widget.imageController.images.length < 3) {
                if (index == 0) {
                  return _buildUploadButton();
                }
                final imgIdx = index - 1;
                if (imgIdx < widget.imageController.images.length) {
                  return _buildPhotoItem(widget.imageController.images[imgIdx], imgIdx);
                }
                return Container();
              }
              return _buildPhotoItem(widget.imageController.images[index], index);
            }),
          ),
        ),
      ]
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: () async {
        final picked = await _picker.pickMultiImage(limit: 3);
        if (picked.isNotEmpty) {
          setState(() {
            widget.imageController.addImages(picked);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Center(
          child: Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPhotoItem(XFile file, int idx) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ImageViewer(imagePath: file.path),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: FileImage(File(file.path)),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.imageController.removeImageAt(idx);
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
