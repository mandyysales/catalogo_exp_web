import 'package:catalogo_exp_web/bloc/auth/auth_bloc.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_event.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/widgets/TextFormField.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class FormCadastro extends StatefulWidget {
  final String title; 
  final String nameButton;

  const FormCadastro({
    required this.title,
    required this.nameButton,
    super.key,
  });

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController funcaoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool obscureSenha = true;

  @override
  void dispose() {
    nomeController.dispose();
    funcaoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 497,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(236, 236, 236, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.crimsonText(
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 25),

          // NOME
          CustomTextField(
            label: "Nome",
            controller: nomeController,
          ),
          const SizedBox(height: 16),

          // FUNÇÃO
          CustomTextField(
            label: "Função",
            controller: funcaoController,
          ),
          const SizedBox(height: 16),

          // EMAIL
          CustomTextField(
            label: "Email",
            controller: emailController,
          ),
          const SizedBox(height: 16),

          // SENHA com ícone
          TextField(
            controller: senhaController,
            obscureText: obscureSenha,
            decoration: InputDecoration(
              labelText: "Senha",
              filled: true,
              fillColor: const Color.fromARGB(255, 251, 251, 251), 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), 
                borderSide: BorderSide.none, 
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.orange, width: 2), 
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureSenha ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscureSenha = !obscureSenha;
                  });
                },
              ),

            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.bottomRight,
            child: CustomButtonRetangularGrande(
              text: widget.nameButton,
              backgroundColor: AppColors.orange,
              onPressed: () {
                context.read<AuthBloc>().add(
                  SignUpRequested(
                    nome: nomeController.text.trim(),
                    funcao: funcaoController.text.trim(),
                    email: emailController.text.trim(),
                    senha: senhaController.text.trim(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
