


import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/dashboard.dart';
import 'package:flutter_dashboard/pages/signout/signout.dart';
import 'package:flutter_dashboard/widgets/loding.dart';

import '../pages/auth/login.dart';
import '../widgets/app_toast.dart';

class AuthController{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signing with email
  static Future<bool> signInWithEmailAndPassword({required BuildContext context, required String email, required String pass}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = userCredential.user;
      //check user role and navigate to respective screen
      var users = await _firestore.collection("users").doc(user?.email).get();
      //update user device token

      print("user login");
      if(users.data()!["role"] == "Admin"){
        await _firestore.collection('users').doc(user?.email).set({...users.data()!, "token" : ""}, SetOptions(merge: true)).then((value) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoard()), (route) => false);
          AppToast.showToast("Login Success", Colors.green);
        });

      }else{
        AppToast.showToast("You are not admin. Thanks.", Colors.red);
      }
      AppToast.showToast( "Login Success", Colors.green);
      return true;
    } on FirebaseAuthException catch (e) {
      if(e.code == "firebase_auth/invalid-credential"){ // The supplied auth credential is incorrect
        AppToast.showToast("The supplied auth credential is incorrect", Colors.red);
      }
      print('Error during email/password sign in: $e');
      return false;

      // Handle different Firebase Auth exceptions (e.g., invalid email, wrong password)
    }
  }




  //logout
  static Future<void> signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
        AppToast.showToast("Sign out success", Colors.green);
      });
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  static Future<void> deleteAccount(context) async {
    try {

      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the user account
        await user.delete();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)), (route) => false);


        print("User account deleted successfully");
      } else {
        print("No user signed in");
      }
    } catch (e) {
      print("Error deleting user account: $e");
    }
  }


  static   Future<void> resetPassword({required String email, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      // Password reset email sent successfully
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordSuccess(email: email)));
      AppToast.showToast("Password reset email sent successfully", Colors.green);
      print("Password reset email sent successfully");
      // You can navigate to a success screen or show a success message here
    } catch (e) {
      // An error occurred while sending the password reset email
      print("Error sending password reset email: $e");
      // You can display an error message to the user
    }
  }

  //change email
  static Future<bool> changeEmail ({required String email, required BuildContext context})async {
    try {
      appLoading(context);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateEmail(email).then((value){
          //change email from user collection
          _firestore.collection("users").doc(user.email).update({"email": email}).then((value) {
            signOut(context);
            AppToast.showToast("Email has been changed", Colors.green);
          });

        });
        return true;
      }
      return false;
    }catch(e){
      print("Error changing email: $e");
      AppToast.showToast("Error changing email", Colors.red);
      Navigator.pop(context);
      return false;
    }
  }

  //change password
  static Future<bool> changePassword ({required String pass, required BuildContext context})async {

    try {
      appLoading(context);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(pass).then((value) {
          Navigator.pop(context);
          AppToast.showToast("Password has been changed", Colors.green);
        });
        return true;
      }
      return false;
    }catch(e){
      AppToast.showToast("Please login again", Colors.red);
      print("Error changing password: $e");
      Navigator.pop(context);

      //AppToast.showToast("Error changing password", Colors.red);
      return false;
    }
  }

  //add privacy
  static Future<void> addPrivacy({required String privacy, required BuildContext context}) async {
    try {
      appLoading(context);
      await _firestore.collection("privacy").doc("privacy").update({"privacy": privacy}).then((value) {
        Navigator.pop(context);
        AppToast.showToast("Privacy has been added", Colors.green);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppToast.showToast("The password provided is too weak", Colors.red);
      } else if (e.code == 'email-already-in-use') {
        AppToast.showToast("The account already exists for that email", Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  //add privacy
  static Future<void> addTerms({required String terms, required BuildContext context}) async {
    try {
      appLoading(context);
      await _firestore.collection("privacy").doc("privacy").update({"terms": terms}).then((value) {
        Navigator.pop(context);
        AppToast.showToast("Privacy has been added", Colors.green);
      });
    } on FirebaseAuthException catch (e) {

    } catch (e) {
      print(e);
    }
  }

  //get privacy
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getPrivacy()  {
    return  _firestore.collection("privacy").doc("privacy").snapshots();
  }

}