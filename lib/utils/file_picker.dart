import 'dart:io';

// import 'package:beichee/utils/toasts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromCamera() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image =await imagePicker.pickImage(source: ImageSource.camera);
  return image;
}
Future<XFile?> pickImageFromGalley() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image =await imagePicker.pickImage(source: ImageSource.gallery);
  return image;
}
