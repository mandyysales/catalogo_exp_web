
import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaInicial extends StatelessWidget{
    const TelaInicial({Key? key}) : super(key : key);
    
    @override
    Widget build(BuildContext context){
        return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    SizedBox(height: 80),
                    Flexible(
                    child: Text(
                        "Catalogo de Materiais do Explora",
                        style: AppTextStyles.titleLarge(AppColors.black),
                        textAlign: TextAlign.center,
                    ),
                    ),

                    SizedBox(height: 100),
                    CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/atom_entrada.png"),
                    ),
                    SizedBox(height: 90),
                    CustomButtonRetangularGrande(text: "Entrar Sem Cadastro", onPressed: (){context.push(AppRoutes.home);/*Navigator.pushNamed(context, "/home");*/}, backgroundColor: AppColors.orange),
                    SizedBox(height: 20),
                    CustomButtonRetangularGrande(text: "Entar Como Administrador", onPressed: (){context.push(AppRoutes.login);/*Navigator.pushNamed(context, "/login");*/}, backgroundColor: AppColors.blue),
                ],
            ),
        );
    }
}