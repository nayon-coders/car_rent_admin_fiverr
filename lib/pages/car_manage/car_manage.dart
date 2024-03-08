import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/pages/car_manage/widgets/openAppDawerWIthInfo.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';

import '../../Responsive.dart';
import '../../const.dart';
import '../../widgets/app_text.dart';
import '../home/widgets/header_widget.dart';

class CarManagement extends StatefulWidget {

  const CarManagement({super.key});

  @override
  State<CarManagement> createState() => _CarManagementState();
}

class _CarManagementState extends State<CarManagement> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot<Object?>? existingDocument;

  bool _isOpeCarInfo = true;

  final _searchText = TextEditingController();
  var search = "";

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child:CarInfoAppDrawer(document: existingDocument,),
      ),


      body: SizedBox(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appTitle(text: "Car Management", context: context),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DashBoard(pageIndex: 7),
                                      settings: RouteSettings(name: 'add-new-car')),
                                );
                              },
                              child: Text('Add Car'),
                            ),
                            SizedBox(width: 20,),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.amber),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DashBoard(pageIndex: 8),
                                      settings: RouteSettings(name: 'add-new-category')),
                                );
                              },
                              child: Text('Category'),
                            ),
                            SizedBox(width: 20,),
                            SizedBox(
                              width: 200,
                              height: 35,
                              child: TextField(
                                controller: _searchText,
                                onChanged: (v){
                                  setState(() {
                                    search = v;
                                  });
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: cardBackgroundColor,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide:
                                      BorderSide(color: Theme.of(context).primaryColor),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    hintText: 'Search',
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 21,
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    _height(context),
                     StreamBuilder(
                       stream: _firestore.collection("cars").snapshots(),
                       builder: (_, snapshot){
                         if(snapshot.connectionState == ConnectionState.waiting){
                           return Center(child: CircularProgressIndicator(),);
                         }else if(snapshot.hasData){
                           List data = [];
                            snapshot.data!.docs.forEach((element) {
                              if (_searchText.text.isNotEmpty) {
                                if (element['name'].toString().toLowerCase().contains(search.toLowerCase())) {
                                  data.add(element);
                                }
                              }else {
                                data.add(element);
                              }
                            });
                           return ConstrainedBox(
                               constraints: const BoxConstraints(minWidth: double.infinity),
                             child: DataTable(

                               columns: [
                                 DataColumn(label: Text("ID")),
                                 DataColumn(label: Text("Image")),
                                 DataColumn(label: Text("Name")),
                                 //DataColumn(label: Text("Price")),
                                 //DataColumn(label: Text("Rent Type")),
                                 DataColumn(label: Text("Status")),
                                 DataColumn(label: Text("Action")),
                               ],
                               rows: data.map<DataRow>(( document){
                                 return DataRow(
                                   //color: MaterialStateProperty.all(Colors.grey[200]),
                                   cells: [
                                     DataCell(Text( document["id"])),
                                     DataCell(AppNetworkImage(imageUrl: document['image'], width: 50, height: 50,)),
                                     DataCell(Text(document['name'])),
                                    // DataCell(Text(document['rentPrice'])),
                                    // DataCell(Text(document['rent_type'])),
                                     DataCell( Container(
                                         padding: EdgeInsets.all(3),
                                         decoration: BoxDecoration(
                                           color: document!['status'] == "active" ? Colors.green : Colors.red,
                                           borderRadius: BorderRadius.circular(5),
                                         ),
                                         child: Text(document!['status'], style: TextStyle(color: Colors.white),)
                                     )),
                                     DataCell(Row(
                                       children: [
                                         IconButton(
                                           icon: Icon(Icons.visibility),
                                           onPressed: (){
                                             setState(() {
                                               existingDocument = document;
                                               _isOpeCarInfo = true;
                                             });
                                             if(existingDocument != null){
                                               scaffoldKey.currentState!.openDrawer();
                                             }
                                             print("scaffoldKey.currentState!.isEndDrawerOpen; ${scaffoldKey.currentState!.isEndDrawerOpen}");
                                           },
                                         ),
                                         IconButton(
                                           icon: Icon(Icons.edit, color: Colors.amber,),
                                           onPressed: (){
                                             Navigator.push(
                                               context,
                                               MaterialPageRoute(builder: (context) => DashBoard(pageIndex: 7, document: document),
                                                 settings: RouteSettings(name: 'edit-car', arguments: document),
                                               ),
                                             );
                                           },
                                         ),
                                         IconButton(
                                           icon: Icon(Icons.delete, color: Colors.red,),
                                           onPressed: () {
                                             showDialog(
                                                 context: context,
                                                 builder: (context) =>
                                                     AlertDialog(
                                                       title: Text(
                                                           "Are you sure?"),
                                                       content: Text(
                                                           "Do you want to delete this car?"),
                                                       actions: [
                                                         TextButton(
                                                           onPressed: () {
                                                             Navigator.pop(
                                                                 context);
                                                           },
                                                           child: Text("Cancel"),
                                                         ),
                                                         TextButton(
                                                           onPressed: () async {
                                                             await _firestore
                                                                 .collection(
                                                                 "cars")
                                                                 .doc(document.id)
                                                                 .delete()
                                                                 .then((value) {
                                                               AppToast.showToast(
                                                                   "Car has been deleted",
                                                                   Colors.green);
                                                               Navigator.pop(
                                                                   context);
                                                             });
                                                           },
                                                           child: Text("Delete"),
                                                         )
                                                       ],
                                                     )
                                             );
                                           }
                                         ),

                                       ],
                                     ))
                                   ]
                                 );
                               }).toList(),
                             ),
                           );
                         }else{
                           return Center(child: Text("No car found"));
                         }
                       },
                     )

                  ],
                ),
              )
          )
      ),
    );
  }


}
