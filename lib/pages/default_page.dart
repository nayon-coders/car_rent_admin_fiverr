import 'package:flutter/material.dart';

import '../../Responsive.dart';
import 'home/widgets/header_widget.dart';

class CarManagement extends StatefulWidget {

  const CarManagement({super.key});

  @override
  State<CarManagement> createState() => _CarManagementState();
}

class _CarManagementState extends State<CarManagement> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
                  Header(scaffoldKey: scaffoldKey),
                  _height(context),
                ],
              ),
            )
        )
    );
  }
}
