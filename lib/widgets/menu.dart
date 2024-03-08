import 'package:flutter/material.dart';
import 'package:flutter_dashboard/Responsive.dart';
import 'package:flutter_dashboard/model/menu_modal.dart';
import 'package:flutter_svg/svg.dart';

class Menu extends StatefulWidget {
  final Widget widget;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Menu({super.key, required this.scaffoldKey, required this.widget});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/car.svg', title: "Car Management"),
    MenuModel(icon: 'assets/svg/message.svg', title: "Message's"),
    MenuModel(icon: 'assets/svg/request.svg', title: "Rent Request"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "User Management"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Setting"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          color: const Color(0xFF171821)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: Responsive.isMobile(context) ? 40 : 80,
            ),
                Expanded(
                  //height: MediaQuery.of(context).size.height,
                  child:   widget.widget
                )


              ],
            ),
      ),
    );
  }
}
