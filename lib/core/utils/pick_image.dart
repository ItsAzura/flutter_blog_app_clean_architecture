import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickedImageResult {
  final File? file;
  final Uint8List? bytes;
  PickedImageResult({this.file, this.bytes});
}

Future<PickedImageResult?> pickImage() async {
  try {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      if (kIsWeb) {
        final bytes = await xFile.readAsBytes();
        return PickedImageResult(bytes: bytes);
      } else {
        return PickedImageResult(file: File(xFile.path));
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}
