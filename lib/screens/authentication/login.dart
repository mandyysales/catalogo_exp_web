import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:catalogo_exp_web/widgets/forms_login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.root);
            }
          },
        ),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primeiro lado - Formulário
                FormLogin(
                  title: "Faça Login:",
                  nameButton: "Login",
                ),

                const SizedBox(width: 190),

                // Segundo lado - Informações
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Importante!",
                          style: GoogleFonts.crimsonText(
                            color: AppColors.cinzaAzul,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "O Login como adm é só para pessoas autorizadas.",
                          style: GoogleFonts.crimsonText(
                            color: AppColors.cinzaAzul,
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "Se você não tem nenhuma relação com administração do laboratório, por favor entre sem cadastro.",
                          style: GoogleFonts.crimsonText(
                            color: AppColors.cinzaAzul,
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 160),
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.grey, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Ainda não tem cadastro?",
                  style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.grey, thickness: 1)),
              ],
            ),
            const SizedBox(height: 30),
            CustomButtonRetangularGrande(
              text: "Cadastre-se",
              onPressed: () {context.push(AppRoutes.cadastro);/*Navigator.pushNamed(context, '/cadastro');*/},
              backgroundColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
