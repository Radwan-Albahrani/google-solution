import 'package:flutter/material.dart';

class RoundedFormField extends StatelessWidget {
  const RoundedFormField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
