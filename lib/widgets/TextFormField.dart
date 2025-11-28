import 'package:catalogo_exp_web/them/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 50,
      child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, 
        filled: true,
        fillColor: const Color.fromARGB(255, 251, 251, 251), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide.none, 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.orange, width: 2), 
        ),
      ),
    ),
    );
  }
}
