import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';


class ChatDetailUserInfo extends StatelessWidget {
  final Map<String, dynamic> user;
  const ChatDetailUserInfo({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: user!["car"]["image"] != null ? AppNetworkImage(imageUrl: user!["car"]["image"]!): Icon(Icons.person, color: Colors.black,),
      ),
      title:Text("Car Name: ${user!["car"]["name"]}"),
      subtitle: Text("User Name: ${user!["user"]["name"]}",
        style: TextStyle(
            color:  Colors.grey
        ),
      ),
    );
  }
}

