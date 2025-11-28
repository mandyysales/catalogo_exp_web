

import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonRetangularGrande extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomButtonRetangularGrande({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed, 
      child: Text(text, style: AppTextStyles.small(AppColors.white)), 
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        fixedSize: Size(270, 45),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        )
      )
    );
  }
}