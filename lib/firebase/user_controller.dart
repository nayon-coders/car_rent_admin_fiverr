import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';
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

}