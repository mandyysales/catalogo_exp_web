
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CusttomButtonRadiusPequeno extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CusttomButtonRadiusPequeno({
    required this.text,
    required this.onPressed,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
    onPressed: onPressed, 
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(
      text,
      style: AppTextStyles.small(AppColors.white)
      )
    );
  }
}