import 'package:flutter/material.dart';

import 'app_text.dart';

class AppSideBySideText extends StatelessWidget {
  const AppSideBySideText({
    super.key, required this.title, required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white
            ),),
          SizedBox(width: 5,),
          Flexible(
              child: appText(text: text, context: context))
        ],
      ),
    );
  }
}