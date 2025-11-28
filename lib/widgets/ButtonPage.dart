import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonPage extends StatelessWidget {
  final String nome;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonPage({
    required this.nome,
    required this.color,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 18),
      label: Text(
        nome,
        style: AppTextStyles.small(AppColors.black)
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(220, 42),
        backgroundColor: AppColors.white,
        shadowColor: color,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide( 
            color: color,
            width: 2,
          ),
        ),
      ),
    );
  }
}
