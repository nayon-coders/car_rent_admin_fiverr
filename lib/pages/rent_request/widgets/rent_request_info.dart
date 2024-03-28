import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/firebase/car_controller/car_controller.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';

import '../../../firebase/messaging_controller.dart';

Future<void> showRentRequestInfo({required BuildContext context, required DocumentSnapshot document}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Details'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10,),
                          AppNetworkImage(imageUrl: document['user']["image"] ?? "", height: 200, width: 200),
                          SizedBox(height: 10,),
                          Text('Name: ${document["user"]['name'] ?? ""}'),
                          SizedBox(height: 5,),
                          Text('Email: ${document["user"]['email'] ?? ""}'),

                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Car Information",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          AppNetworkImage(imageUrl: document['car']["image"], height: 200, width: 200),
                          SizedBox(height: 10,),
                          Text('Car: ${document['car']["name"]}'),
                          SizedBox(height: 5,),
                          Text('Request For: '),
                          SizedBox(height: 5,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54
                            ),
                            child: ListTile(
                              title: Text(document["rent_type"]["rent_type"]),
                              trailing: Text(document["rent_type"]["rent_price"]),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Divider(),
                SizedBox(height: 10,),
                Text("Request Information",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                Text('Status: ${document["status"]}'),
                SizedBox(height: 8,),
                Text('Date: ${document["createdAt"]}'),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          MessagingController.sendMessage(message: "Hello", receiverEmail: document["user"]["email"] ?? "", user: document["user"] as Map<String, dynamic>, docId: 'message_start', car: document["car"] as Map<String, dynamic>,).then((value) {
                            print("this is messages === ${value}");
                            if (value) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      DashBoard(pageIndex: 2,),
                                  settings: RouteSettings(name: 'messaging')));
                            }
                          });
                        },
                        child: Text('Start chat'),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)
                        ),
                        onPressed: () {
                          CarController.changeCarRequestStatus(docId: document.id, carId: document["car"]["id"], status: "approved", context: context);
                        },
                        child: Text('Approve'),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red)
                        ),
                        onPressed: () {
                          CarController.changeCarRequestStatus(docId: document.id, carId: document["car"]["id"], status: "cancel", context: context);
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}