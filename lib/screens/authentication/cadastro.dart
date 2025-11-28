import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/widgets/forms_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(46),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primeiro lado - Formulário
            FormCadastro(
              title: "Cadastre-se:",
              nameButton: "Enviar Solicitação",
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
                      "Requisitos",
                      style: GoogleFonts.crimsonText(
                        color: AppColors.cinzaAzul,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "- Professor \n- Direção ou Administração \n- Alunos (autorizados)",
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
      ),
    );
  }
}
