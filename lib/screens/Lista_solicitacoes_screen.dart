import 'package:catalogo_exp_web/bloc/auth/auth_bloc.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_event.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_state.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/card_lista_solicitacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaSolicitacoesScreen extends StatefulWidget {
  const ListaSolicitacoesScreen({super.key});

  @override
  State<ListaSolicitacoesScreen> createState() => _ListaSolicitacoesScreenState();
}

class _ListaSolicitacoesScreenState extends State<ListaSolicitacoesScreen> {
  @override
  void initState() {
    super.initState();
    // pedir para o bloc buscar os usuários pendentes
    context.read<AuthBloc>().add(CarregarUsuariosPendentesEvent());
  }

  // ---- POPUP DE CONFIRMAÇÃO (ACEITAR) ----
  Future<void> _confirmAceitar(BuildContext context, String uid, String nome) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar aprovação'),
        content: Text('Deseja aprovar o usuário "$nome" como auxiliar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (ok == true) {
      context.read<AuthBloc>().add(AprovarUsuarioEvent(uid));
    }
  }

  // ---- POPUP DE CONFIRMAÇÃO (NEGAR) ----
  Future<void> _confirmRecusar(BuildContext context, String uid, String nome) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar recusa'),
        content: Text('Deseja remover a solicitação de "$nome"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (ok == true) {
      context.read<AuthBloc>().add(DesautorizarUsuarioEvent(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solicitações de cadastro',
          style: AppTextStyles.titleSmall(AppColors.orange)
        ),
        backgroundColor: AppColors.lightGrey,
        elevation: 0,
      ),

      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is UsuariosPendentesCarregandoState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsuariosPendentesErroState) {
            return Center(child: Text("Erro ao carregar solicitações."));
          }

          if (state is UsuariosPendentesCarregadosState) {
            final usuarios = state.usuarios;

            if (usuarios.isEmpty) {
              return const Center(child: Text("Nenhuma solicitação pendente."));
            }

            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final user = usuarios[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CardListaSolicitacao(
                    nome: user.nome,
                    funcao: user.funcao,
                    email: user.email,
                    onPressed1: () => _confirmAceitar(context, user.uid, user.nome),
                    onPressed2: () => _confirmRecusar(context, user.uid, user.nome),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
