import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../firebase/car_controller/car_controller.dart';
import '../../../firebase/messaging_controller.dart';
import 'chat_details_user_info.dart';

class MessageBody extends StatefulWidget {
  final String docIS;

  const MessageBody({
    super.key,  required this.docIS,
  });

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody> {
  final ScrollController _controller = ScrollController();

  final _auth = FirebaseAuth.instance;

  final _messageController = TextEditingController();

  //
  // final ScrollController _controller = ScrollController();
  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.8,
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10)
            ),

            child: widget.docIS.isEmpty
                ? Center(child: Text("No message found"),)
                : StreamBuilder(
                    stream: MessagingController.getMessagesWithDocId(docId: widget.docIS),
                    builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey.shade800,
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          }else if(snapshot.hasData) {
                            return  ListView(
                              children: [
                                ChatDetailUserInfo(data: snapshot.data!.data()!,),
                                SizedBox(height: 5,),
                                // Row(
                                //   children: [
                                //     ElevatedButton(
                                //         style: ButtonStyle(
                                //             backgroundColor: MaterialStateProperty.all(Colors.green)
                                //         ),
                                //         onPressed: () {
                                //           CarController.changeCarRequestStatus(docId: widget.docIS, carId: snapshot.data!.data()!["car"]["id"], status: "approved", context: context);
                                //         },
                                //         child: const Text("Accept the request")
                                //     ),
                                //     SizedBox(width: 20,),
                                //     ElevatedButton(
                                //         style: ButtonStyle(
                                //             backgroundColor: MaterialStateProperty.all(Colors.red)
                                //         ),
                                //         onPressed: () {
                                //           CarController.changeCarRequestStatus(docId: widget.docIS, carId: snapshot.data!.data()!["car"]["id"], status: "cancel", context: context);
                                //         },
                                //         child: const Text("Cancel the request")
                                //     )
                                //   ],
                                // ),
                                // SizedBox(height: 5,),
                                //show request status

                                SizedBox(height: 5,),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.6,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:  ListView.builder(
                                    controller: _controller,
                                    itemCount: snapshot.data!.data()!["message"].length,
                                    itemBuilder: (_, index) {
                                      var msg = snapshot.data!.data()!["message"].toList()[index];
                                      return Column(
                                        children: [
                                          msg["sender"] == _auth.currentUser!.email
                                              ?  Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              //height: MediaQuery.of(context).size.height*0.5,
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: ListTile(
                                                title: Container(
                                                    margin: EdgeInsets.only(bottom: 8),
                                                    padding: EdgeInsets.only(left: 15, right: 15,top: 5, bottom: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Text("${msg["message"]}",
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15
                                                      ),
                                                    )
                                                ),
                                                subtitle: Text("${msg["timestamp"]}",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                              :  Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              //height: MediaQuery.of(context).size.height*0.5,
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.3,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(Icons.person,
                                                    color: Colors.black,),
                                                ),
                                                title: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8),
                                                    padding: EdgeInsets.only(left: 15,
                                                        right: 15,
                                                        top: 5,
                                                        bottom: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .circular(10)
                                                    ),
                                                    child: Text("${msg["message"]}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15
                                                      ),
                                                    )
                                                ),
                                                subtitle: Text("${msg["timestamp"]}",
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  )
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextField(
                                            onTap: () {
                                              _controller.jumpTo(_controller.position.maxScrollExtent);
                                            },
                                            controller: _messageController,
                                            decoration: InputDecoration(
                                                hintText: "Type a message",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        10),
                                                    borderSide: BorderSide.none
                                                ),
                                                filled: true,
                                                fillColor: Colors.black
                                            ),
                                          )
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: ()async{
                                          await MessagingController.sendMessage(
                                              message: _messageController.text,
                                              receiverEmail: snapshot.data!.data()!["user"]["email"],
                                              user: snapshot.data!.data()!["user"],
                                              docId: widget.docIS,
                                              car: snapshot.data!.data()!["car"]
                                          ).then((value) {
                                            _messageController.clear();
                                            print("Message sent");
                                            _controller.jumpTo(_controller.position.maxScrollExtent);
                                          });

                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.send, color: Colors.white,),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }else {
                            return Center(child: Text("No message found"),);
                          }
                    },
                  ),
           ),
        );
  }
}
