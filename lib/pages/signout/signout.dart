import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/authController.dart';

import '../../Responsive.dart';
import '../../widgets/app_text.dart';
import '../home/widgets/header_widget.dart';

class SignOut extends StatefulWidget {

  const SignOut({super.key});

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //AuthController.signOut(context);
  }

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
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 400,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: appTitle(text: "Are you sure you want to sign out?", context: context)),
                            SizedBox(height: 20,),
                            ElevatedButton(
                              onPressed: () {
                                AuthController.signOut(context);
                              },
                              child: Text("Sign Out"),
                            )
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )
        )
    );
  }
}
