import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/messages/widgets/chat_details_user_info.dart';
import 'package:flutter_dashboard/pages/messages/widgets/message_body.dart';
import 'package:flutter_dashboard/pages/messages/widgets/message_user_list.dart';
import 'package:flutter_dashboard/pages/messages/widgets/single_user_list_chat.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../Responsive.dart';
import '../../firebase/messaging_controller.dart';
import '../home/widgets/header_widget.dart';

class Messages extends StatefulWidget {

  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _openChat = false;
  String docId = "";

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 15 : 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.isMobile(context) ? 5 : 18,
                  ),
                  Header(scaffoldKey: scaffoldKey),
                  _height(context),
                  appTitle(text: "Message's", context: context),
                  _height(context),
                  Row(
                    children: [
                      StreamBuilder(
                          stream: MessagingController.getAllMessages(),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Container(
                                width: 300,
                                color: Colors.grey.shade800,
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: Shimmer.fromColors(
                                  child: Container(height: 80, color: Colors.grey.shade800,),
                                  baseColor: Colors.grey.shade800,
                                  highlightColor: Colors.grey.shade600,
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
                                    return UserListChat( snapshot: snapshot.data!.docs![index], onTap: () {
                                      setState(() {
                                        _openChat = true;
                                        docId = snapshot.data!.docs[index].id;
                                      });

                                    },);
                                  },
                                ),
                              );
                            }else{
                              return Center(child: Text("Chat is empty"),);
                            }
                          }
                      ),
                      SizedBox(width: 10,),
                      MessageBody(docIS: docId,),
                      SizedBox(height: 30,),
                    ],
                  )

                ],
              ),
            )
        )
    );
  }
}



