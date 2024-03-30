import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/authController.dart';
import 'package:flutter_dashboard/pages/setting/widgets/banner_upload_view.dart';
import 'package:flutter_dashboard/pages/setting/widgets/social_meida_view.dart';
import 'package:flutter_dashboard/widgets/app_input.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';

import '../../Responsive.dart';
import '../home/widgets/header_widget.dart';

class Setting extends StatefulWidget {

  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _password = TextEditingController();
  final _cPassword = TextEditingController();

  final _currentEmail = TextEditingController();
  final _newEmail = TextEditingController();

  final _appPrivacy = TextEditingController();
  final _appTerms = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _emailChangeKey = GlobalKey<FormState>();
  final _changePrivacy = GlobalKey<FormState>();
  final _changeTerms = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   setState(() {
     _currentEmail.text = FirebaseAuth.instance.currentUser!.email!;
   });
  }

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,

        title: Text('Setting', style: TextStyle(fontSize: 16),),
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
                    _height(context),
                    SizedBox(
                      height: 300,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appTitle(text: "Change admin password", context: context),
                            _height(context),
                            AppInput(
                              hintText: "Password",
                              controller: _password,
                              title: "New Password",
                              validator: (v){
                                if(v!.isEmpty){
                                  return "Password is required";
                                }
                                if(v.length < 6){
                                  return "Password must be at least 6 characters";
                                }

                              },
                            ),
                            SizedBox(height: 15,),
                            AppInput(
                                hintText: "Confirm Password",
                                controller: _cPassword,
                                title: "Confirm Password",
                                validator: (v){
                                  if(v!.isEmpty){
                                    return "Password is required";
                                  }
                                  if(v != _password.text){
                                    return "Password does not match";
                                  }
                                }
                            ),
                            SizedBox(height: 30,),
                            ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    AuthController.changePassword(context: context, pass: _password.text);
                                  }
                                },
                                child: Text("Change password")
                            )
                          ],
                        ),
                      ),
                    ),
                    _height(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(child: BannerAddView()),

                        SizedBox(width: 20,),
                         Expanded(
                             child: SocialMediaView()
                         )
                        // Expanded(
                        //   child: Form(
                        //     key: _emailChangeKey,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         appTitle(text: "Change admin email", context: context),
                        //         _height(context),
                        //         AppInput(
                        //           readOnly: true,
                        //           hintText: "Current Login Email",
                        //           controller: _currentEmail,
                        //           title: "Current Login Email",
                        //         ),
                        //         SizedBox(height: 15,),
                        //         AppInput(
                        //             hintText: "New Login Email",
                        //             controller: _newEmail,
                        //             title: "New Login Email",
                        //             validator: (v){
                        //               if(v!.isEmpty){
                        //                 return "Email is required";
                        //               }
                        //               if(v.contains("@") != true && v!.contains(".") != truead){
                        //                 return "Password does not match";
                        //               }
                        //             }
                        //         ),
                        //         SizedBox(height: 30,),
                        //         ElevatedButton(
                        //             onPressed: (){
                        //               if(_emailChangeKey.currentState!.validate()){
                        //                 AuthController.changeEmail(context: context, email: _newEmail.text);
                        //               }
                        //             },
                        //             child: Text("Change Email")
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    _height(context),
                    StreamBuilder(
                      stream: AuthController.getPrivacy(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }else if(snapshot.hasData){
                          _appPrivacy.text = snapshot.data!["privacy"];
                          _appTerms.text = snapshot.data!["terms"];
                          return Row(
                            children: [
                              Expanded(
                                child: Form(
                                  key: _changePrivacy,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      appTitle(text: "Change App Privacy", context: context),
                                      SizedBox(height: 15,),
                                      AppInput(
                                        maxLine: 20,
                                        hintText: "Change App Privacy",
                                        controller: _appPrivacy,
                                      ),
                                      SizedBox(height: 30,),
                                      ElevatedButton(
                                          onPressed: (){
                                            if(_changePrivacy.currentState!.validate()){
                                              AuthController.addPrivacy(context: context, privacy: _appPrivacy.text);
                                            }
                                          },
                                          child: Text("Change Privacy")
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Form(
                                  key: _changeTerms,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      appTitle(text: "Change App Terms & Conditions", context: context),
                                      SizedBox(height: 15,),
                                      AppInput(
                                        maxLine: 20,
                                        hintText: "Change App Terms & Conditions",
                                        controller: _appTerms,
                                      ),
                                      SizedBox(height: 30,),
                                      ElevatedButton(
                                          onPressed: (){
                                            if(_changeTerms.currentState!.validate()){
                                              AuthController.addTerms(context: context, terms: _appTerms.text);
                                            }
                                          },
                                          child: Text("Change Terms & Conditions")
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }else{
                          return Center(child: Text("No data found"),);
                        }

                      }
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
}
