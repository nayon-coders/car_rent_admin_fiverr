import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/car_manage/add_new_category.dart';
import 'package:flutter_dashboard/pages/car_manage/car_manage.dart';
import 'package:flutter_dashboard/pages/home/home_page.dart';
import 'package:flutter_dashboard/pages/messages/messages.dart';
import 'package:flutter_dashboard/pages/rent_request/rent_requests.dart';
import 'package:flutter_dashboard/pages/setting/setting.dart';
import 'package:flutter_dashboard/pages/signout/signout.dart';
import 'package:flutter_dashboard/pages/user_management/user_management.dart';
import 'package:flutter_dashboard/widgets/menu.dart';
import 'package:flutter_dashboard/Responsive.dart';
import 'package:flutter_dashboard/widgets/profile/profile.dart';
import 'package:flutter_svg/svg.dart';

import 'model/menu_modal.dart';
import 'pages/car_manage/add_new_car.dart';

class DashBoard extends StatefulWidget {
  final DocumentSnapshot<Object?>? document;
  final int pageIndex;
  DashBoard({super.key,  this.pageIndex = 0, this.document});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  List<Widget> pages = [];

  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/car.svg', title: "Car Management"),
    MenuModel(icon: 'assets/svg/message.svg', title: "Message's"),
    MenuModel(icon: 'assets/svg/request.svg', title: "Booking Manage"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "User Management"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Setting"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPage = widget.pageIndex;
    //init pages
    pages.insert(0, HomePage(scaffoldKey: _scaffoldKey));
    pages.insert(1, CarManagement());
    pages.insert(2, Messages());
    pages.insert(3, RentRequest());
    pages.insert(4, UserManagement());
    pages.insert(5, Setting());
    pages.insert(6, SignOut());
    pages.insert(7, AddNewCar(document: widget.document));
    pages.insert(8, AddNewCategory());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        drawer:!Responsive.isDesktop(context) ? SizedBox(width: 250,
        child: Menu(scaffoldKey: _scaffoldKey, widget: SizedBox(),)) :null,
        endDrawer:Responsive.isMobile(context) ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Profile()) : null,
        body: SafeArea(
          child: Row(
            children: [
              if (Responsive.isDesktop(context))
                Expanded(
                  flex: 2,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Menu(
                       widget: ListView.builder(
                         itemCount: menu.length,
                         itemBuilder: (_, index){
                           return  Container(
                             width: MediaQuery.of(context).size.width,
                             margin: const EdgeInsets.symmetric(vertical: 5),
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.all(
                                 Radius.circular(6.0),
                               ),
                               color: _currentPage == index
                                   ? Theme.of(context).primaryColor
                                   : Colors.transparent,
                             ),
                             child: InkWell(
                               onTap: () {
                                 setState(() {
                                   _currentPage = index;
                                 });
                               },
                               child: Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 13, vertical: 7),
                                     child: SvgPicture.asset(
                                       menu[index].icon,
                                       height: 20,
                                       width: 20,
                                       color: _currentPage == index ? Colors.black : Colors.grey,
                                     ),
                                   ),
                                   Text(
                                     menu[index].title,
                                     style: TextStyle(
                                         fontSize: 16,
                                         color: _currentPage == index ? Colors.black : Colors.grey,
                                         fontWeight: _currentPage == index
                                             ? FontWeight.w600
                                             : FontWeight.normal),
                                   )
                                 ],
                               ),
                             ),
                           );
                         }
                       ),
                          scaffoldKey: _scaffoldKey
                      )
                  ),
                ),
              Expanded(flex: 8, child: pages[_currentPage]),
              // if (!Responsive.isMobile(context))
              //   const Expanded(
              //     flex: 4,
              //     child: Profile(),
              //   ),
            ],
          ),
        ));
  }
}
