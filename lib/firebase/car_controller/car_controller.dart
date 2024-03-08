import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';
import 'package:intl/intl.dart';

import '../../widgets/loding.dart';

class CarController{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  //add car
  static Future<bool> addNewCar({required Map<String, dynamic> data, required BuildContext context})async{
    try{
      //add car to firestore
      await _firestore.collection("cars").add(data).then((value) {
        AppToast.showToast("New cars has been added. ", Colors.green);
        //Navigator.pop(context);
      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }
  
  //edit car
  static Future<bool> editCar({required Map<String, dynamic> data, required String docId,  required BuildContext context})async{
    try{
      //add car to firestore
      await _firestore.collection("cars").doc(docId).update(data).then((value) {
        AppToast.showToast("Car information has been updated.", Colors.green);
        Navigator.pop(context);
      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }

  //change status
  static Future<bool> changeStatus({required String docId, required String status, required BuildContext context})async{
    try{
      //add car to firestore
      await _firestore.collection("cars").doc(docId).update({"status": status}).then((value) {
        AppToast.showToast("Car status has been updated.", Colors.green);
        Navigator.pop(context);
      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }

  //add category
  static Future<bool> addCategory({required String category, required String image, required BuildContext context})async{
    try{
      int id = DateTime.now().millisecondsSinceEpoch;
      //add car to firestore
      await _firestore.collection("category").add({
        "image": image,
        "createBy": _auth.currentUser!.email,
        "category": category,
        "createdAt": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "id" : id.toString()
      }).then((value) {
        AppToast.showToast("New category has been added.", Colors.green);
      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }

  //edit category
  static Future<bool> editCategory({required String category, required String image, required String docId, required BuildContext context})async{
    try{
      //add car to firestore
      await _firestore.collection("category").doc(docId).update({
        "image": image,
        "category": category,
        "createdAt": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      }).then((value) {
        AppToast.showToast("Category information has been updated.", Colors.green);
      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }

  //delete car
  static Future<bool> deleteCategory ({required String docId, required BuildContext context})async{
    try{
      _firestore.collection("category").doc(docId).delete().then((value){
        AppToast.showToast("Category has been deleted.", Colors.green);
        Navigator.pop(context);
      });
      return true;
    }catch(e){
      return false;
    }
  }


  //get total cars
  static Future<int> getTotalCars()async{
    QuerySnapshot snapshot = await _firestore.collection("cars").get();
    return snapshot.docs.length;
  }
  //get total car request
  static Future<int> getTotalCarRequest()async{
    QuerySnapshot snapshot = await _firestore.collection("rent_request").get();
    return snapshot.docs.length;
  }
  //get total user
  static Future<int> getTotalUser()async{
    QuerySnapshot snapshot = await _firestore.collection("users").get();
    return snapshot.docs.length;
  }
  //get total rent car
  static Future<int> getTotalRentCar()async{
    QuerySnapshot snapshot = await _firestore.collection("cars").get();
    for(var i in snapshot.docs){
      print("${i["status"]}");
      if(i["status"] == "rent"){
        return snapshot.docs.length;
      }else{
        return 0;
      }
    }
    return 0;
  }





  //get rest request
  static Stream<QuerySnapshot<Map<String, dynamic>>> getCarRequest(){
    return  _firestore.collection("car_request").snapshots();
  }

  //change status of reny request and car
  static Future<bool> changeCarRequestStatus({required String docId, required String carId, required String status, required BuildContext context})async{
    try{
      appLoading(context);
      //add car to firestore
      await _firestore.collection("rent_request").doc(docId).update({"status": status}).then((value) {
        var carStatus = status == "approved" ? "rent" : "active";
         _firestore.collection("cars").doc(carId).update({"status": carStatus}).then((value) {
          AppToast.showToast("Car request status has been updated.", Colors.green);
          Navigator.pop(context);
          Navigator.pop(context);
        });

      });
      //add car image to firebase storage
      return true;
    }catch(e){
      return false;
    }
  }

}