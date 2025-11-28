import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Títulos
  static TextStyle titleLarge(Color color) { //Nome pagina inicial e Explora(pag Home)
    return GoogleFonts.playfairDisplay(
      fontSize: 50, 
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle titleMedium(Color color) { //Categorias  (pag Detalhes Equip),
    return GoogleFonts.playfairDisplay(
      fontSize: 45, 
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle titleSmall(Color color) { //Nome_Categoria (pag Detalhes Equip)
    return GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle titleSmallx(Color color) {
    return GoogleFonts.inter(
      fontSize: 35,
      fontWeight: FontWeight.w800,
      color: color,
    );
  }


  // Texto normal
  static TextStyle bodyLight(Color color) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  // Pequeno
  static TextStyle small(Color color) { // ButtonPage, custom_button_radius_peque
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
