// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final bool isEnabled;
  final String? label;
  final TextInputType keyboardType;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.obscureText,
    this.hintText,
    this.label,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          enabled: isEnabled,
          labelStyle: const TextStyle(fontSize: 18),
          hintText: hintText,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          // ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 3),
          ),
          // fillColor: Colors.grey.shade200,
          // filled: true,
        ),
      ),
    );
  }
}
