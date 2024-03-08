import 'package:flutter/material.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/firebase/authController.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';

import '../../widgets/app_input.dart';
import '../../widgets/app_text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _pasword = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 500,
          height: 400,
          decoration: BoxDecoration(
            color: Color(0xFF171821),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              appTitle(text: "Admin Login", context: context),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    AppInput(
                      title: "Email",
                      hintText: "Email",
                      controller: _email,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AppInput(
                      title: "Password",
                      hintText: "Password",
                      controller: _pasword,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        setState(() => _isLoading = true);
                        await AuthController.signInWithEmailAndPassword(context: context, email: _email.text, pass: _pasword.text, ).then((value) {
                          if(value){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard(), settings: RouteSettings(name: 'dashboard')));
                          }else{
                            AppToast.showToast("Invalid Login Credential", Colors.red);
                          }

                        });
                        setState(() => _isLoading = false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) :  Text('Login'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
