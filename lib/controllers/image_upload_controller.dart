import 'package:image_picker/image_picker.dart';

class ImageUploadController {
  final List<XFile> images = [];

  void addImages(List<XFile> newImages) {
    images.addAll(newImages);
    if (images.length > 3) {
      images.removeRange(0, images.length - 3);
    }
  }

  void removeImageAt(int index) {
    images.removeAt(index);
  }
}
