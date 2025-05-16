import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCrop {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestPermission() async {
    final storageStatus = await Permission.storage.request();
    final cameraStatus = await Permission.camera.request();
    return storageStatus.isGranted && cameraStatus.isGranted;
  }

  Future<XFile?> takePhoto() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<CroppedFile?> cropImage(String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '크롭 이미지',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '크롭 이미지',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
  }

  Future<XFile?> compressImage(String imagePath) async {
    try {
      final outputPath = imagePath.replaceAll(RegExp(r"(\.[^.]*)\$"), '_compressed.webp');
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        outputPath,
        format: CompressFormat.webp,
        quality: 88,
      );
      if (compressedFile == null) return null;
      return XFile(compressedFile.path);
    } catch (e) {
      return null;
    }
  }
}