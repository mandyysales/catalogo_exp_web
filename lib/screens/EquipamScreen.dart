import 'package:catalogo_exp_web/bloc/auth/auth_bloc.dart';
import 'package:catalogo_exp_web/bloc/auth/auth_state.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/router/Rotas.dart';
//import 'package:catalogo_exp_web/objetos/Equipamento.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/ButtonPage.dart';
//import 'package:catalogo_exp_web/widgets/ButtonPage.dart';
//import 'package:catalogo_exp_web/widgets/TextFormIcon.dart';
import 'package:catalogo_exp_web/widgets/cards_equipamentos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Equipamscreen extends StatefulWidget {
  const Equipamscreen({super.key});

  @override
  State<Equipamscreen> createState() => _EquipamscreenState();
}

class _EquipamscreenState extends State<Equipamscreen> {
  @override
  void initState() {
    super.initState();
    // dispara carregamento inicial (stream)
    context.read<EquipamentoBloc>().add(LoadEquipamentosEvent());
  }

  @override
  Widget build(BuildContext context) {
    // pega o estado de autenticação para saber se mostra botões de edição/exclusão
    final authState = context.watch<AuthBloc>().state;
    final bool autorizado =
        authState is AuthenticatedState ? authState.autorizado : false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Equipamentos', style: AppTextStyles.titleSmall(AppColors.orange)),
        backgroundColor: AppColors.lightGrey,
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: BlocListener<EquipamentoBloc, EquipamentoState>(
        listenWhen: (_, state) => state is EquipamentoLoaded,
        listener: (context, state) {
          // assim que tiver carregado, pedimos o agrupamento
          context.read<EquipamentoBloc>().add(AgruparPorCategoriaEvent());
        },
        child: BlocBuilder<EquipamentoBloc, EquipamentoState>(
          builder: (context, state) {
            if (state is EquipamentoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EquipamentoAgrupado) {
              final Map<String, List<Equipamento>> categorias = state.grupos;

              if (categorias.isEmpty) {
                return const Center(child: Text("Nenhum equipamento encontrado"));
              }

              // Usamos CustomScrollView + SliverToBoxAdapter, igual à Home
              return CustomScrollView(
                slivers: [
                  // opcional: um pequeno topo
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonPage(
                            nome: "Inicio",
                            color: AppColors.orange,
                            icon: Icons.home,
                            onPressed: () {
                              context.push(AppRoutes.home);
                            },
                          ),
                          const SizedBox(width: 20),
                          ButtonPage(
                            nome: "Equipamentos",
                            color: AppColors.orange,
                            icon: Icons.settings,
                            onPressed: () {
                             context.push(AppRoutes.equipamentos);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),


                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        'Categorias:',
                        style: AppTextStyles.titleMedium(AppColors.cinzaAzul)
                      ),
                    ),
                  ),

                  // Para cada categoria, criamos um SliverToBoxAdapter com título + lista horizontal
                  for (final entry in categorias.entries) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          entry.key,
                          style: AppTextStyles.titleSmall(AppColors.orange)
                        ),
                      ),
                    ),

                    // espaço entre título e lista
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 12),
                    ),

                    // lista horizontal dentro de um SliverToBoxAdapter usando SizedBox com altura fixa
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 260, // altura dos cards — harmonizada com a Home
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: entry.value.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final equipamento = entry.value[index];
                            return CustomCardEquipamentos(
                              equipamento: equipamento,
                              editar: autorizado,
                            );
                          },
                        ),
                      ),
                    ),

                    // espaço entre categorias
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 28),
                    ),
                  ],
                ],
              );
            }

            // estados fallback: erro / vazio
            if (state is EquipamentoError) {
              return Center(child: Text('Erro: ${state.message}'));
            }

            // estado padrão
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}