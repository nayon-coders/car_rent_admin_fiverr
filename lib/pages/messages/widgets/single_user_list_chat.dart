import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/user_controller.dart';

import 'message_body.dart';


class UserListChat extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> snapshot;
  final VoidCallback onTap;

  const UserListChat({super.key, required this.snapshot, required this.onTap});

  @override
  State<UserListChat> createState() => _UserListChatState();
}

class _UserListChatState extends State<UserListChat> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(6.0),
          ),
          color: Colors.transparent,
        ),
        child: InkWell(
            child: ListTile(
              onTap:widget.onTap,
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black,),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 25),
                  //     width: 10,
                  //     height: 10,
                  //     decoration: BoxDecoration(
                  //         color:  Colors.red,
                  //         borderRadius: BorderRadius.circular(10)
                  //     ),
                  //   ),
                  // )
                ],
              ),
              title:Text("${widget.snapshot!["receiver"]["name"]}"),
              subtitle: Text("${widget.snapshot!["message"].toList().last["message"]}",
                style: TextStyle(
                    color:widget.snapshot!["message"].toList().last["read"] == true ? Colors.grey : Colors.white
                ),
              ),
            )
        ),
      ),
    );
  }
}
