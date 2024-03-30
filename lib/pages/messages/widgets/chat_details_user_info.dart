import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';


class ChatDetailUserInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  const ChatDetailUserInfo({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: data!["car"]["image"] != null ? AppNetworkImage(imageUrl: data!["car"]["image"]!): Icon(Icons.person, color: Colors.black,),
      ),
      title:Text("Car Name: ${data["car"]["name"]}"),
      subtitle: Text("User Name: ${data!["user"]["name"]}",
        style: TextStyle(
            color:  Colors.grey
        ),
      ),
    );
  }
}

