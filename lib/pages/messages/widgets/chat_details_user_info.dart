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
        child: user!["profile"] != null ? AppNetworkImage(imageUrl: user!["profile"]!): Icon(Icons.person, color: Colors.black,),
      ),
      title:Text("${user!["name"]}"),
      subtitle: Text("${user!["email"]}",
        style: TextStyle(
            color:  Colors.grey
        ),
      ),
    );
  }
}

