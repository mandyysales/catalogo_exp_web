import 'package:catalogo_exp_web/them/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleButtonDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const SingleButtonDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.blue,
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.lightGrey)),
      content: Text(message, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.lightGrey)),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300, color: AppColors.white)),
        ),
      ],
    );
  }
}
