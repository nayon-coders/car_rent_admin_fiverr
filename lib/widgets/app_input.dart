import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.title = "",
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.maxLine = 1,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Function(String?)? onChanged;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != ""
            ? Text(
              "$title",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 14),
            )
            : SizedBox(),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.white
          ),
           maxLines: maxLine,
          onChanged: onChanged,
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xff434343),
            contentPadding: EdgeInsets.only(left: 15, top: 15, right: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
               borderSide: BorderSide.none,),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none),
            hintText: "$hintText",
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.grey[400]),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
          validator: validator,
        )
      ],
    );
  }
}
