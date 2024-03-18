import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../appConfig.dart';

class NotificationController{

  //send notification to user
  static Future<bool> sendNotification({required String title, required String body, required List<String> token, required Map<String, dynamic> car })async{
    var res = await http.post(Uri.parse(AppConfig.NOTIFICATION_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : "key=AAAA0DS5MXE:APA91bHq-GaxYeEIxS_5QY9s0-RjKZS0NOh9Hs4_jRJDyjRzq-6tbLWdgjL7z-JkyQwF4XpvLVXlYZMGxh1ZOARa-LcFgYSwMYqLf8iZoj_nr4fIi0F_WIStANWi7VALSQZ1WcSQa8ex"
        },
        body: jsonEncode({
          "registration_ids": token,
          "notification": {
            "body": body,
            "title": title,
            "android_channel_id": "pushnotificationapp",
            "sound": false,
            "payload": "data",
          },
          "data": {
            "message": body,
            "car" : car
          }
        }
        )
    );
    print("notification send ${token}");
    print("notification send ${res.body}");
    print("notification send ${res.statusCode}");
    if(res.statusCode == 200){
      print("notification send");
      return true;
    }else{
      return false;
    }
  }

}