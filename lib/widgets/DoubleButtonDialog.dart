import 'package:catalogo_exp_web/them/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoubleButtonDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DoubleButtonDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.red,
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.lightGrey),),
      content: Text(message, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.lightGrey),),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(cancelText, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300, color: AppColors.white),),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text(confirmText, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300, color: AppColors.black)),
        ),
      ],
    );
  }
}
