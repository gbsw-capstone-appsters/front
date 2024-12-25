import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String textfield_name;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.textfield_name,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 52, right: 52),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Color(0xff648DFC)),
          labelText: textfield_name,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff648DFC)),
          ),
        ),
      ),
    );
  }
}
