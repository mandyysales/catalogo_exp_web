import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/widgets/TextFormField.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class FormLogin extends StatefulWidget {
  final String title;
  final String nameButton;

  const FormLogin({
    super.key,
    required this.title,
    required this.nameButton,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool mostrarSenha = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is AuthenticatedState) {
          context.pop(AppRoutes.home);
        }
      },
      child: Container(
        alignment: Alignment.centerRight,
        width: 497,
        height: 330,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(236, 236, 236, 1),
          borderRadius: BorderRadius.circular(25),
        ),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: GoogleFonts.crimsonText(
                      fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(height: 25),

              // EMAIL
              CustomTextField(
                label: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 16),

              // SENHA
              TextFormField(
                controller: senhaController,
                obscureText: !mostrarSenha,
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
                      mostrarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarSenha = !mostrarSenha;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.bottomRight,
                child: CustomButtonRetangularGrande(
                  text: widget.nameButton,
                  backgroundColor: AppColors.orange,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            LogInRequested(
                              email: emailController.text.trim(),
                              senha: senhaController.text.trim(),
                            ),
                          );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
