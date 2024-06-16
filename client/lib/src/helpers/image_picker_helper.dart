import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker picker = ImagePicker();

  static Future<File?> pickImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }
}
