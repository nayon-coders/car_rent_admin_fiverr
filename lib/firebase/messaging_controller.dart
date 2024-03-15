import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MessagingController {

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> sendMessage({String? docId, required String message, required String receiverEmail, required Map<String, dynamic> user, required Map<String, dynamic> car}) async {
    var sender= {};
   _firestore.collection('users').doc(_auth.currentUser!.email).get().then((admin) {

     //check messages is exist or not
      _firestore.collection('messages').doc(docId).get().then((value) {
        if(value.exists){
          //if exist then update the message
          _firestore.collection('messages').doc(docId).update({
            'message': FieldValue.arrayUnion([
              {
                'sender': _auth.currentUser!.email,
                'receiver': receiverEmail,
                'message': message,
                'timestamp': DateFormat('yyyy-MM-dd – hh:mm:ss').format(DateTime.now()),
                "read": false,
              }
            ]),
            'timestamp': FieldValue.serverTimestamp(),
          });
        }else{
          //if not exist then create new message
          _firestore.collection('messages').add({
            'user' : user,
            "admin" : admin.data(),
            "car" : car,
            'message': [
              {
                'sender': _auth.currentUser!.email,
                'receiver': receiverEmail,
                'message': message,
                'timestamp': DateFormat('yyyy-MM-dd – hh:mm:ss').format(DateTime.now()),
                "read": false,
              }
            ],
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

     //  _firestore.collection('messages').doc(receiverEmail).set({
     //   'receiver' : user,
     //   "sender" : value.data(),
     //   'message': [
     //     {
     //       'senderId': _auth.currentUser!.email,
     //       'receiverId': receiverEmail,
     //       'message': message,
     //       'timestamp': DateFormat('yyyy-MM-dd – hh:mm:ss').format(DateTime.now()),
     //       "read": true,
     //     }
     //   ],
     //   'timestamp': FieldValue.serverTimestamp(),
     // });
    });
    });
  }

  //get all messages
  static Stream<QuerySnapshot> getAllMessages() {
      return _firestore.collection('messages').snapshots();
  }
  //get messages with document id
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getMessagesWithDocId({required String docId}) {
    return _firestore.collection('messages').doc(docId).snapshots();
  }

  //get messages
  static Stream<QuerySnapshot> getMessages({required String receiverEmail}) {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('messages')
          .where('senderId', isEqualTo: user.email)
          .where('receiverId', isEqualTo: receiverEmail)
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    return Stream.empty();
  }

}
