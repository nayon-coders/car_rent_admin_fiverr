import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/rent_request/widgets/rent_request_info.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';

import '../../Responsive.dart';
import '../../const.dart';
import '../../dashboard.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_toast.dart';
import '../home/widgets/header_widget.dart';

class RentRequest extends StatefulWidget {

  const RentRequest({super.key});

  @override
  State<RentRequest> createState() => _RentRequestState();
}

class _RentRequestState extends State<RentRequest> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  //request string list
  List<String> requestList = ["All request", "Pending", "Approve", "Cancel"];
  String? _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   setState(() {
     _selectedIndex = requestList[0];
   });
  }
  final _searchText = TextEditingController();
  var search = "";

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Booking List', style: TextStyle(fontSize: 16),),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ListView.builder(
                            itemCount: requestList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = requestList[index];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: _selectedIndex == requestList[index] ? Colors.blue : Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: Text("${requestList[index]}", style: TextStyle(color: _selectedIndex == requestList[index] ? Colors.white : Colors.black),)
                                ),
                              );
                            },
                          ),
                        ),

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
                    ),

                    SizedBox(height: 20,),
                    appTitle(text: "$_selectedIndex List", context: context),
                    SizedBox(height: 20,),
                    //table
                    StreamBuilder(
                      stream: _firestore.collection("rent_request").snapshots(),
                      builder: (_, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }else if(snapshot.hasData){
                          List data = [];
                          //status filter
                          for(var i in snapshot.data!.docs){
                            if(_searchText.text.isNotEmpty) {
                              if (i['car']['name'].toString()
                                  .toLowerCase()
                                  .contains(_searchText.text.toLowerCase())) {
                                data.add(i);
                              }
                            }else{
                              if(_selectedIndex == "Pending"){
                                if(i['status'] == "pending"){
                                  data.add(i);
                                }
                              }else if(_selectedIndex == "Approve"){
                                if(i['status'] == "approved"){
                                  data.add(i);
                                }
                              }else if(_selectedIndex == "Cancel"){
                                if(i['status'] == "cancel"){
                                  data.add(i);
                                }
                              }else if(_selectedIndex == "All request"){
                                data.add(i);
                              }
                            }

                          }

                          return   SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                            child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth,
                                      ),
                                      child: data.isEmpty ? Center(child: SizedBox(height: 200, child: Text("Fo request found")),) : DataTable(
                                        columns: [
                                          DataColumn(label: Text("ID")),
                                          DataColumn(label: Text("Car Image")),
                                          DataColumn(label: Text("Car Name")),
                                          DataColumn(label: Text("User name")),
                                          DataColumn(label: Text("Date")),
                                          DataColumn(label: Text("Status")),
                                          DataColumn(label: Text("Pay Status")),
                                          DataColumn(label: Text("Action")),
                                        ],
                                        rows: data.map<DataRow>((document){
                                          return DataRow(
                                            //color: MaterialStateProperty.all(Colors.grey[200]),
                                              cells: [
                                                DataCell(Text( document["id"])),
                                                DataCell(AppNetworkImage(imageUrl: document["car"]['image'], height: 50, width: 50,)),
                                                DataCell(Text(document["car"]['name'])),
                                                DataCell(Text(document["user"]['name'])),
                                                DataCell(Text(document['createdAt'])),
                                                DataCell( Container(
                                                    padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                                                    decoration: BoxDecoration(
                                                      color: document['status'] == "approved" ? Colors.green :  document['status'] == "cancel" ? Colors.red : Colors.blue,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(document['status'], style: TextStyle(color: Colors.white),)
                                                )),
                                                DataCell( Container(
                                                    padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                                                    decoration: BoxDecoration(
                                                      color: document['pay_status'] == "paid" ? Colors.green : Colors.red,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(document['pay_status'], style: TextStyle(color: Colors.white),)
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.visibility),
                                                      onPressed: (){
                                                        showRentRequestInfo(context: context, document: document);
                                                      },
                                                    ),

                                                  ],
                                                ))
                                              ]
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                }
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
