import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/user_controller.dart';

import '../../Responsive.dart';
import '../../const.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_text.dart';
import '../home/widgets/header_widget.dart';

class UserManagement extends StatefulWidget {

  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List _statusList = ['All', 'Active', 'Inactive']; //['All', 'Active', 'Inactive'];
  String _selectedIndex = 'All';

  final _searchText = TextEditingController();
  String search = '';
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('User Management', style: TextStyle(color: Colors.white, fontSize: 16)),
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
                            itemCount: _statusList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = _statusList[index];
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: _selectedIndex == _statusList[index] ? Colors.blue : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text("${_statusList[index]}", style: TextStyle(color: _selectedIndex == _statusList[index] ? Colors.white : Colors.black),)
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
                      stream: _firestore.collection("users").snapshots(),
                      builder: (_, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }else if(snapshot.hasData){
                          List data = [];
                          //status filter
                          for(var i in snapshot.data!.docs) {
                            if (i["role"] != "Admin") {
                              if (_searchText.text.isNotEmpty) {
                                if (i['name'].toString()
                                    .toLowerCase()
                                    .contains(_searchText.text.toLowerCase())) {
                                  data.add(i);
                                }
                              } else {
                                if (_selectedIndex == "Active") {
                                  if (i['status'] == "active") {
                                    data.add(i);
                                  }
                                } else if (_selectedIndex == "Inactive") {
                                  if (i['status'] == "inactive") {
                                    data.add(i);
                                  }
                                } else if (_selectedIndex == "All") {
                                  data.add(i);
                                }
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
                                      child: data.isEmpty ? Center(child: SizedBox(height: 200, child: Text("No user found.")),) : DataTable(
                                        columns: [
                                          DataColumn(label: Text("ID")),
                                          DataColumn(label: Text("profile")),
                                          DataColumn(label: Text("Name")),
                                          DataColumn(label: Text("Email")),
                                          DataColumn(label: Text("Date")),
                                          DataColumn(label: Text("Status")),
                                          DataColumn(label: Text("Action")),
                                        ],
                                        rows: data.map<DataRow>((document){
                                          return DataRow(
                                            //color: MaterialStateProperty.all(Colors.grey[200]),
                                              cells: [
                                                DataCell(Text( document["id"])),
                                                DataCell(AppNetworkImage(imageUrl: document['profile'], height: 50, width: 50,)),
                                                DataCell(Text(document['name'])),
                                                DataCell(Text(document['email'])),
                                                DataCell(Text(document['createdAt'])),
                                                DataCell( Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: document['status'] == "active" ? Colors.green :  document['status'] == "inactive" ? Colors.red : Colors.blue,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(document['status'], style: TextStyle(color: Colors.white),)
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      primary: document["status"] == "active" ? Colors.red : Colors.green,
                                                      elevation: 1,
                                                    ),
                                                        onPressed: ()=>_changeStatusPopup(document),
                                                        child: Text("${document["status"] == "active" ? "Inactive" : "Active"}", style: TextStyle(color: Colors.white),)
                                                    )

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
  //show alert dialog
  Future<void> _changeStatusPopup(dynamic documents) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure? Do you want to change the status?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                if(documents["status"] == "active"){
                 UserController.updateUserStatus("inactive", documents.id, context);
                }else{
                  UserController.updateUserStatus("active", documents.id, context);
                }
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
