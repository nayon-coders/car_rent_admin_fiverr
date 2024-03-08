import 'package:flutter/material.dart';

import '../../Responsive.dart';

Text appTitle({required String text, required BuildContext context}) {
  return Text(
    '$text',
    style: TextStyle(
      color: Colors.grey,
      fontSize: Responsive.isDesktop(context) ? 18 : 14,
      fontWeight: FontWeight.w500
    ),
  );
}

 Text appText({required String text, required BuildContext context}) {
  return Text(
    '$text',
    style: TextStyle(
      color: Colors.grey,
      fontSize: Responsive.isDesktop(context) ? 14 : 12,
    ),
  );
}