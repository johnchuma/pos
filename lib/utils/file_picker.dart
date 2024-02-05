


import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromCamera() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image =await imagePicker.pickImage(source: ImageSource.camera,imageQuality:40 );
  return image;
}
Future<XFile?> pickImageFromGalley() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image =await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 60);
  return image;
}
