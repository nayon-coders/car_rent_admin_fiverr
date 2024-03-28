import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';
import 'package:flutter_dashboard/widgets/image_controller.dart';
import 'package:flutter_dashboard/widgets/loding.dart';

class UserController{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  //get all user
  static Stream<QuerySnapshot> getAllUser(){
    return _firestore.collection('users').snapshots();
  }

  //update user status
  static Future<void> updateUserStatus(String status, String docId, BuildContext context) async{
    appLoading(context);
    await _firestore.collection('users').doc(docId).update({
      'status': status
    }).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      AppToast.showToast("Status has been changed", Colors.green);
    });
  }

  //get user info with email address
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() {
    //get user list
     _firestore.collection('users')..get().then((value) {
      value.docs.forEach((element) {
        //get all messages and check if the user is the sender or receiver
        _firestore.collection("messages").where("receiverId", isEqualTo: element["email"]).get().then((value) {
          print(value.docs.length);
        });
      });
    });


    return Stream.empty();

  }
  
  
  //get social media
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSocialMedia(){
    return _firestore.collection("social_media").snapshots();
  }

  //add social media
  static Future<void> addSocialMedia({required String name, required String url, required Uint8List image, required BuildContext context }) async{
    appLoading(context);
    //image convert
    var convertedImage;
    if(image.isEmpty){
      Navigator.pop(context);
      AppToast.showToast("Please select an image", Colors.red);
      return;
    }else{
      ImageController.uploadImageToFirebaseStorage(image, "social_media").then((value) async{
        await _firestore.collection('social_media').add({
          'name': name,
          'url': url,
          'image': value
        }).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppToast.showToast("Social Media has been added", Colors.green);
        });
      });
    }
  }

  //delete socail media
  static Future<void> deleteSocialMedia(String docId, BuildContext context) async{
    appLoading(context);
    await _firestore.collection('social_media').doc(docId).delete().then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      AppToast.showToast("Social Media has been deleted", Colors.green);
    });
  }

  //edit social media
  static Future<void> editSocialMedia({required String name, required String url, required Uint8List? image, required String docId, required BuildContext context }) async{
    appLoading(context);
    //image convert
    var convertedImage;
    if(image == null){
      await _firestore.collection('social_media').doc(docId).update({
        'name': name,
        'url': url,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        AppToast.showToast("Social Media has been updated", Colors.green);
      });
    }else{
      ImageController.uploadImageToFirebaseStorage(image!, "social_media").then((value) async{
        await _firestore.collection('social_media').doc(docId).update({
          'name': name,
          'url': url,
          'image': value
        }).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppToast.showToast("Social Media has been updated", Colors.green);
        });
      });
    }
  }


  //add banner
  static Future<void> addBanner({required String status, required Uint8List image, required BuildContext context }) async{
    appLoading(context);
    //image convert
    var convertedImage;
    if(image.isEmpty){
      Navigator.pop(context);
      AppToast.showToast("Please select an image", Colors.red);
      return;
    }else{
      ImageController.uploadImageToFirebaseStorage(image, "banner").then((value) async{
        await _firestore.collection('banner').add({
          'status': status,
          'url': value,
        }).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppToast.showToast("Banner has been added", Colors.green);
        });
      });
    }
  }

  //get banner
  static Stream<QuerySnapshot<Map<String, dynamic>>> getBanner(){
    return _firestore.collection("banner").snapshots();
  }

  //delete banner
  static Future<void> deleteBanner(String docId, BuildContext context) async{
    appLoading(context);
    await _firestore.collection('banner').doc(docId).delete().then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      AppToast.showToast("Banner has been deleted", Colors.green);
    });
  }

  //edit banner
  static Future<void> editBanner({required String status, required Uint8List? image, required String docId, required BuildContext context }) async{
    appLoading(context);
    //image convert
    var convertedImage;
    if(image == null){
      await _firestore.collection('banner').doc(docId).update({
        'status': status,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        AppToast.showToast("Banner has been updated", Colors.green);
      });
    }else{
      ImageController.uploadImageToFirebaseStorage(image, "banner").then((value) async{
        await _firestore.collection('banner').doc(docId).update({
          'status': status,
          'url': value,
        }).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppToast.showToast("Banner has been updated", Colors.green);
        });
      });
    }
  }

}