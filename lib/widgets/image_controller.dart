import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ImageController{

  //conver image for firebase
  static Future<String> uploadImageToFirebaseStorage(Uint8List imageFile, String pathName) async {
    try {
      var storageReference = FirebaseStorage.instance.ref().child('$pathName/${DateTime.now().millisecondsSinceEpoch}');
      var uploadTask = storageReference.putData(imageFile);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("downloadUrl file == ${downloadUrl}");
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  static Future<Uint8List?> startWebFilePicker() async {
    Uint8List ? image;
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      print("this is files === $files");
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        image = const Base64Decoder().convert(reader.result.toString().split(",").last);

      });
      reader.readAsDataUrl(file);

    });
    return image;
  }

}