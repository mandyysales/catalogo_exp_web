
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:flutter/material.dart';
// Renomear para Campo Pesquisar 
class TextformIcon extends StatelessWidget {
  final String campo;
  final IconData icone;
  final TextEditingController controller;
  final Color cor; 
  final VoidCallback onPressed;

  TextformIcon({required this.campo, required this.icone, required this.controller, required this.cor, required this.onPressed});

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: 800,
      height: 60,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: cor,
              offset: Offset(0, 10),
              blurRadius: 50,
              spreadRadius: -10
            )
          ]
        ),
        child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: campo,
          labelStyle: TextStyle(color: AppColors.grey),
          filled: true,
          fillColor: AppColors.white,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_forward, color: AppColors.grey,),
          ),
          prefixIcon: Icon(icone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.orange, width: 2),
            borderRadius: BorderRadius.circular(30),
          )
        ),
      ),
    );
  }

}