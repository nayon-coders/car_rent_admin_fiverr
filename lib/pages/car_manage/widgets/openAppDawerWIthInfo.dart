import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';

import '../../../firebase/car_controller/car_controller.dart';
import '../../../widgets/side_by_side_text.dart';

class CarInfoAppDrawer extends StatefulWidget {
  final DocumentSnapshot<Object?>? document;
  CarInfoAppDrawer({super.key, this.document});

  @override
  _CarInfoAppDrawerState createState() => new _CarInfoAppDrawerState();
}

class _CarInfoAppDrawerState extends State<CarInfoAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: AppNetworkImage(
                imageUrl: widget.document!['image'],
              ),
            ),
           Padding(
             padding: EdgeInsets.all(20),
             child: Column(
               children: [
                 AppSideBySideText(title: "Car Name", text: widget.document!['name']),
                 AppSideBySideText(title: "Year", text: widget.document!['year']),
                 AppSideBySideText(title: "Transmission", text: widget.document!['transmission']),
                  AppSideBySideText(title: "Fuel Type", text: widget.document!['fuelType']),
                  AppSideBySideText(title: "Engin capacity", text: widget.document!['enginCapacity']),
                 AppSideBySideText(title: "Price", text: "${widget.document!['rentPrice']}/${widget.document!['rent_type']}"),

                 AppSideBySideText(title: "Description", text: widget.document!['descriptions']),
                 Padding(
                   padding: const EdgeInsets.only(bottom: 10.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Status: ",
                         style: TextStyle(
                             fontWeight: FontWeight.w500,
                             fontSize: 15,
                             color: Colors.white
                         ),),
                       SizedBox(width: 5,),
                       Container(
                         padding: EdgeInsets.all(3),
                         decoration: BoxDecoration(
                           color: widget.document!['status'] == "active" ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(5),
                         ),
                         child: Text(widget.document!['status'], style: TextStyle(color: Colors.white),)
                       )
                     ],
                   ),
                 ),
                 AppSideBySideText(title: "Date: ", text: widget.document!['createdAt']),
                 AppSideBySideText(title: "Category: ", text: widget.document!['category']["category"]),
                 appTitle(text: "Rent Info", context: context),
                 SizedBox(height: 5,),
                 ListView.builder(
                   shrinkWrap: true,
                   itemCount: widget.document!["rent_type"].length,
                   itemBuilder: (context, index){
                     var _selectedRentTypeAndPrice = widget.document!["rent_type"];
                     return ListTile(
                       title: Text("Rent Type: ${_selectedRentTypeAndPrice[index]["rent_type"]}"),
                       subtitle: Text("Rent Price: ${_selectedRentTypeAndPrice[index]["rent_price"]}"),
                     );
                   },
                 ),

                 SizedBox(height: 30,),
                 ElevatedButton(
                     onPressed: (){
                       showDialog(
                           context: context,
                           builder: (BuildContext context) {
                             return AlertDialog(
                               content: widget.document!['status'] == "active" ? Text("Are you sure you want to deactivate this car?") :  Text("Are you sure you want to active this car?"),
                               actions: [
                                 TextButton(
                                     onPressed: (){
                                       Navigator.pop(context);
                                     },
                                     child: Text("Cancel")),
                                 TextButton(
                                     onPressed: ()async{
                                       widget.document!['status'] == "active" ? await CarController.changeStatus(docId: widget.document!.id, status: "deactivate", context: context).then((value) {
                                         if(value){
                                           Navigator.pop(context);
                                         }
                                       }
                                       ) : await CarController.changeStatus(docId: widget.document!.id, status: "active", context: context).then((value) {
                                         if(value){
                                           Navigator.pop(context);
                                         }
                                       }
                                       );
                                     },
                                     child:  widget.document!['status'] == "active" ? Text("Deactivate") : Text("Active"))
                               ],
                             );
                           }
                       );
                     },
                   style: ElevatedButton.styleFrom(
                       primary: widget.document!['status'] == "active" ?  Colors.red : Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                   child: widget.document!['status'] == "active" ? Text("Deactivate") : Text("Active")
                 )



               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}

