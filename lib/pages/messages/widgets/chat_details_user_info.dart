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
<<<<<<< HEAD
        child: data!["car"]["image"] != null ? AppNetworkImage(imageUrl: data!["car"]["image"]!): Icon(Icons.person, color: Colors.black,),
      ),
      title:Text("Car Name: ${data["car"]["name"]}"),
      subtitle: Text("User Name: ${data!["user"]["name"]}",
=======
        child: user!["car"]["image"] != null ? AppNetworkImage(imageUrl: user!["car"]["image"]!): Icon(Icons.person, color: Colors.black,),
      ),
      title:Text("Car Name: ${user!["car"]["name"]}"),
      subtitle: Text("User Name: ${user!["user"]["name"]}",
>>>>>>> 4cb95922c8c2af836dbf1a09d30ff8f853048f11
        style: TextStyle(
            color:  Colors.grey
        ),
      ),
    );
  }
}

