import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textFieldWidget extends StatelessWidget {
  const textFieldWidget(
      {super.key,
      this.controller,
      this.maxLines = 1,
      this.hintText = "Your Name:",
      this.readOnly,
      this.suffixIcon,
      this.obsecure,
      this.icon});
  final TextEditingController? controller;
  final int? maxLines;
  final String? hintText;
  final bool? readOnly;
  final bool? suffixIcon;
  final Widget? icon;
  final bool? obsecure;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: TextField(
          readOnly: readOnly ?? false,
          controller: controller,
          obscureText: obsecure ?? false,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(14.0),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: getInputBorder,
            enabledBorder: getInputBorder,
            border: getInputBorder,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
            ),
            suffixIcon: suffixIcon == true ? icon : null,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder get getInputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide.none,
    );
  }
}
