

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonRetangularMedio extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomButtonRetangularMedio({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context){
      return Container(
        width: 60,
        height: 45,
        child: ElevatedButton(
        onPressed: onPressed, 
        child: Text(text, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)), 
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          //maximumSize: Size(100, 95),
          fixedSize: Size(230, 45),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )
        )
      ),
    );
  }
}