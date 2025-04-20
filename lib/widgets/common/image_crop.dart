// lib/services/image_crop_service.dart
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCrop {
  final ImagePicker _picker = ImagePicker();

  /// 권한 요청 (저장소 + 카메라)
  Future<bool> requestPermission() async {
    final storageStatus = await Permission.storage.request();
    final cameraStatus = await Permission.camera.request();
    return storageStatus.isGranted && cameraStatus.isGranted;
  }

  /// 카메라로 사진 촬영
  Future<XFile?> takePhoto() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  /// 갤러리에서 사진 선택
  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  /// 선택된 이미지를 1:1 비율로 크롭
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

  /// 크롭된 이미지를 WebP 포맷으로 압축 후 XFile로 반환
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
      print('이미지 압축 오류: \$e');
      return null;
    }
  }
}