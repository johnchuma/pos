import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:pos/utils/notifications.dart';
import 'package:share_plus/share_plus.dart';
Future<String?> downloadImage(String imageUrl) async {
      var status = await Permission.storage.request();
    if (status.isGranted) {
   var response = await http.get(Uri.parse(imageUrl));
  
  print(response.statusCode);
  if (response.statusCode == 200) {
    var directory = await getDownloadsDirectory();
    // successNotification(directory?.path);
    var contentType = response.headers['content-type'];
    var fileExtension = '.jpg'; // Default file extension
    if (contentType != null) {
      if (contentType.contains('image/png')) {
        fileExtension = '.png';
      } else if (contentType.contains('image/gif')) {
        fileExtension = '.gif';
      }
    }

    var uri = Uri.parse(imageUrl);
    var fileName = uri.pathSegments.last;
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var uniqueFileName = '$fileName$fileExtension';
    var filePath = '/storage/emulated/0/$uniqueFileName';
    var file = await File(filePath).writeAsBytes(response.bodyBytes);
    return file.path;

    } 
return "";
  
  } else {
    throw Exception('Failed to load image');
  }
}

Future<String?> shareImage(String imageUrl) async {
      var status = await Permission.storage.request();
    if (status.isGranted) {
   var response = await http.get(Uri.parse(imageUrl));
  
  print(response.statusCode);
  if (response.statusCode == 200) {
    var directory = await getDownloadsDirectory();
    // successNotification(directory?.path);
    var contentType = response.headers['content-type'];
    var fileExtension = '.jpg'; // Default file extension
    if (contentType != null) {
      if (contentType.contains('image/png')) {
        fileExtension = '.png';
      } else if (contentType.contains('image/gif')) {
        fileExtension = '.gif';
      }
    }

    var uri = Uri.parse(imageUrl);
    var fileName = uri.pathSegments.last;
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var uniqueFileName = '$fileName$fileExtension';
    var filePath = '/storage/emulated/0/$uniqueFileName';
    var file = await File(filePath).writeAsBytes(response.bodyBytes);
    await Share.shareXFiles([XFile.fromData(response.bodyBytes,name:uniqueFileName,path: filePath)]);
 
    return file.path;

    } 
return "";
  
  } else {
    throw Exception('Failed to load image');
  }
}

