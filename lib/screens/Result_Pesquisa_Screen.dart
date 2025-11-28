import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/TextFormIcon.dart';
import 'package:catalogo_exp_web/widgets/cards_equipamentos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPesquisaScreen extends StatefulWidget {
  const ResultPesquisaScreen({super.key});

  @override
  State<ResultPesquisaScreen> createState() => _ResultPesquisaScreenState();
}

class _ResultPesquisaScreenState extends State<ResultPesquisaScreen> {
  final buscar = TextEditingController();
  String categoriaSelecionada = "Todas";
  String statusSelecionado = "Todos";

  @override
  void dispose() {
    print("Tela Resultados sendo Destruida");
    buscar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // seta de voltar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.orange),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          }
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                TextformIcon(
                  campo: "pesquisar",
                  controller: buscar,
                  onPressed: () {
                    final query = buscar.text;

                    context.read<EquipamentoBloc>().add(
                      BuscarEquipamentoEvent(query: query),
                    );
                  },
                  icone: Icons.search,
                  cor: AppColors.orange,
                ),
                const SizedBox(width: 20),


            const SizedBox(height: 30),

            Text(
              "Resultado:",
              style: AppTextStyles.titleMedium(AppColors.cinzaAzul),
            ),
            const SizedBox(height: 20),

            BlocBuilder<EquipamentoBloc, EquipamentoState>(
              builder: (context, state) {

                if (state is EquipamentoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is EquipamentoError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.crimsonText(
                        color: AppColors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (state is EquipamentoLoaded) {
                  final resultados = state.equipamentos;

                  return SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: resultados.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        return CustomCardEquipamentos(
                          equipamento: resultados[i],
                          editar: false,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),


            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
