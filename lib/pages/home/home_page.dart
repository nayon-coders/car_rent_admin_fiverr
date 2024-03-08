import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/pages/home/widgets/header_widget.dart';
import 'package:flutter_dashboard/pages/rent_request/rent_requests.dart';
import 'package:flutter_dashboard/responsive.dart';
import 'package:flutter_dashboard/pages/home/widgets/activity_details_card.dart';
import 'package:flutter_dashboard/pages/home/widgets/bar_graph_card.dart';
import 'package:flutter_dashboard/pages/home/widgets/line_chart_card.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';

import '../../firebase/car_controller/car_controller.dart';
import '../../widgets/app_network_image.dart';
import '../rent_request/widgets/rent_request_info.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({super.key, required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //total cars length
  int totalCars = 0;
  //total Car request length
  int totalCarRequest = 0;
  //total user length
  int totalUser = 0;
  //total Message length
  int totalRentCar = 0;

  //get total cars length
  getTotalCarLength()async{
    totalCars = await CarController.getTotalCars();
     totalCarRequest = await CarController.getTotalCarRequest();
     totalUser = await CarController.getTotalUser();
     totalRentCar = (await CarController.getTotalRentCar())!;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalCarLength();
  }

  final _firestore = FirebaseFirestore.instance;


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
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 18,
              ),
              Header(scaffoldKey: widget.scaffoldKey),
              _height(context),
              Responsive.isMobile(context)
                  ?Column(
                      children: [
                        ActivityDetailsCard(title: 'Total Product', value: '$totalCars', icon: 'assets/svg/car.svg'),
                        SizedBox(height: 15,),
                        ActivityDetailsCard(title: 'Total Rent Request', value: '$totalCarRequest', icon: 'assets/svg/car.svg'),
                        SizedBox(height: 15,),
                        ActivityDetailsCard(title: 'Total Rent Car', value: '$totalRentCar', icon: 'assets/svg/car.svg'),
                        SizedBox(height: 15,),
                        ActivityDetailsCard(title: 'Total Users', value: '$totalUser', icon: 'assets/svg/car.svg'),
                      ],
                    )
                  : Row(
                children: [
                  Expanded(child: ActivityDetailsCard(
                    title: 'Total Product',
                    value: '$totalCars',
                    icon: 'assets/svg/car.svg',
                    onClick: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 1,), settings: RouteSettings(name: 'car-management'))),
                  ),),
                  SizedBox(width: 15,),
                  Expanded(
                      child: ActivityDetailsCard(
                          title: 'Total Rent Request',
                          value: '$totalCarRequest',
                          icon: 'assets/svg/car.svg',
                        onClick: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 3,), settings: RouteSettings(name: 'rent-request'))),
                      )
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                      child: ActivityDetailsCard(
                          title: 'Total Rent Car',
                          value: '$totalRentCar',
                          icon: 'assets/svg/car.svg',
                        onClick: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 1,), settings: RouteSettings(name: 'rent-request'))),

                      )),
                  SizedBox(width: 15,),
                  Expanded(
                      child: ActivityDetailsCard(
                          title: 'Total Users',
                          value: '$totalUser',
                          icon: 'assets/svg/car.svg',
                        onClick: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(pageIndex: 4,), settings: RouteSettings(name: 'rent-request'))),

                      )),
                ],
              ),
              _height(context),
             // BarGraphCard(),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xff343434)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appTitle(text: "Recent Rent Request", context: context),
                    SizedBox(height: 15,),
                    StreamBuilder(
                      stream: _firestore.collection("rent_request").snapshots(),
                      builder: (_, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }else if(snapshot.hasData){

                          List data = [];
                          //status filter
                          if(snapshot.data!.docs.length > 8 ){
                            data = snapshot.data!.docs.sublist(0, 8);
                          }else{
                            data = snapshot.data!.docs;
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
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      color: document['status'] == "active" ? Colors.green :  document['status'] == "cancel" ? Colors.red : Colors.blue,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(document['status'], style: TextStyle(color: Colors.white),)
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
                    ),
                  ],
                ),
                )
            ],
          ),
        )));
  }
}
