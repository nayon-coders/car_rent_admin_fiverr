import 'package:flutter/material.dart';

Future<void> appLoading(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}