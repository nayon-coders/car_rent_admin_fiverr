import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/user_controller.dart';
import 'package:flutter_dashboard/pages/messages/messages.dart';
import 'package:flutter_dashboard/pages/messages/widgets/single_user_list_chat.dart';
import 'package:shimmer/shimmer.dart';

import '../../../firebase/messaging_controller.dart';


class MessageUserList extends StatelessWidget {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MessagingController.getAllMessages(),
      builder: (context, snapshot) {
       if(snapshot.connectionState == ConnectionState.waiting){
         return Container(
           width: 300,
           color: Colors.grey.shade800,
           height: MediaQuery.of(context).size.height * 0.8,
           child: Shimmer.fromColors(
               child: Container(height: 80, color: Colors.grey.shade800,),
               baseColor: Colors.white,
               highlightColor: Colors.grey.shade800,
           ),
         );
       }else if(snapshot.hasData){
         return Container(
           height: MediaQuery.of(context).size.height * 0.8,
           width: 300,
           decoration: BoxDecoration(
               color: Colors.grey.shade800,
               borderRadius: BorderRadius.circular(10)
           ),
           child: ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (_, index){
               return UserListChat( snapshot: snapshot.data!.docs![index], onTap: () {  },);
             },
           ),
         );
       }else{
          return Center(child: Text("Chat is empty"),);
       }
      }
    );
  }
}
