import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naro/controllers/image_upload_controller.dart';
import 'package:naro/styles/colors.dart';
import 'package:naro/utils/permission_manager.dart';
import 'package:naro/widgets/common/image_viewer.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

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
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
            child: Text('image'.tr(), style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
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
    return InkWell(
      onTap: () async {
        HapticFeedback.lightImpact();
        final isGranted = await PermissionManager().requestCameraPermission(context);
        if (!isGranted) {
          return;
        }
        final picked = await _picker.pickMultiImage(limit: 3);
        if (picked.isNotEmpty) {
          setState(() {
            widget.imageController.addImages(picked);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: UIColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 181, 213, 244)),
        ),
        child: const Center(
          child: Icon(Icons.add_photo_alternate_outlined, size: 40, color: Color(0xFF797979),),
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
