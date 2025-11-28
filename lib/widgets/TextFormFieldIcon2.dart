import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:catalogo_exp_web/them/colors.dart';

class FormFieldCustom extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController? controller;
  final double width;
  final double height;
  final bool readOnly;
  final int? maxLines;
  final VoidCallback? onTap;

   final FormFieldValidator<String>? validator;

  const FormFieldCustom({
    super.key,
    required this.label,
    this.icon,
    this.controller,
    this.width = 400,
    this.height = 55,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255), // fundo cinza claro
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3), // sombra cinza suave
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,

        validator: validator,
        
        style: GoogleFonts.inter(
          color: Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color:Colors.grey[600],
            fontSize: 16,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey[700])
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
