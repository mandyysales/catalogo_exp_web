/*import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/equipamento/equipamento_bloc.dart';
import '../bloc/equipamento/equipamento_event.dart';
import '../bloc/equipamento/equipamento_state.dart';
import '../them/colors.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  void initState() {
    super.initState();
    // DISPARA O EVENTO ASSIM QUE A TELA Favoritos
    BlocProvider.of<EquipamentoBloc>(context).add(FetchFavoritosEvent()); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos", style: AppTextStyles.titleSmall(AppColors.orange)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.orange),
      ),

      body: BlocBuilder<EquipamentoBloc, EquipamentoState>(
        builder: (context, state) {
          print('FAVORITOS_SCREEN: estado = ${state.runtimeType}');
          if (state is EquipamentoFavoritoState) {
            final favoritos = state.favoritos;
            print('FAVORITOS_SCREEN: estado = ${state.runtimeType}');
            if (favoritos.isEmpty) {
              return Center(
                child: Text(
                  "Nenhum equipamento favorito ainda.",
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final e = favoritos[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Informações
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            e.nome,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Marca: ${e.marca}",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.cinzaAzul,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            "Quantidade: ${e.quantidade}",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.cinzaAzul,
                            ),
                          ),
                        ],
                      ),

                      // Botão de remover
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColors.orange),
                        onPressed: () {
                          context.read<EquipamentoBloc>().add(
                            RemoverEquipamentoFavoritoEvent(equipamento: e),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // Estado inicial
          return Center(
            child: Text(
              "Nenhum favorito encontrado.",
              style: GoogleFonts.inter(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}*/

import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/equipamento/equipamento_bloc.dart';
import '../bloc/equipamento/equipamento_event.dart';
import '../bloc/equipamento/equipamento_state.dart';
import '../them/colors.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  bool _isActionRunning = false; // controla cliques rápidos

  @override
  void initState() {
    super.initState();
    // garante que o context exista quando dispararmos o evento
    Future.microtask(() {
      if (mounted) {
        context.read<EquipamentoBloc>().add(FetchFavoritosEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos", style: AppTextStyles.titleSmall(AppColors.orange)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.orange),
      ),

      // BlocConsumer permite separar efeitos (listener) da UI (builder)
      body: BlocConsumer<EquipamentoBloc, EquipamentoState>(
        listener: (context, state) {
          // Sempre cheque mounted antes de usar context em callbacks assíncronos
          if (!mounted) return;

          if (state is EquipamentoError) {
            // Mostra erro via SnackBar (evita chamar quando já desmontado)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message )),
            );
            // garante que botões sejam reabilitados caso tenham sido desabilitados
            setState(() => _isActionRunning = false);
          }

          // Se quiser, trate estados de sucesso para reabilitar UI
          if (state is EquipamentoFavoritoState) {
            setState(() => _isActionRunning = false);
          }

          if (state is EquipamentoLoading) {
            // opcional: você pode mostrar algum indicador global
            // setState(() => _isActionRunning = true);
          }
        },
        buildWhen: (previous, current) {
          // Evita rebuilds desnecessários: reconstrói apenas em estados relevantes
          // Reconstrói quando for EquipamentoFavoritoState, EquipamentoLoading ou EquipamentoError
          return current is EquipamentoFavoritoState ||
                 current is EquipamentoLoading ||
                 current is EquipamentoError;
        },
        builder: (context, state) {
          // debug print controlado
          // print('FAVORITOS_SCREEN: estado = ${state.runtimeType}');

          if (state is EquipamentoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EquipamentoFavoritoState) {
            final favoritos = state.favoritos;
            if (favoritos.isEmpty) {
              return Center(
                child: Text(
                  "Nenhum equipamento favorito ainda.",
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final e = favoritos[index];

                return Container(
                  key: ValueKey(e.id), // importante para estabilidade de widgets
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Informações
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              e.nome,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Marca: ${e.marca}",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.cinzaAzul,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "Quantidade: ${e.quantidade}",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.cinzaAzul,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Botão de remover
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              context.read<EquipamentoBloc>().add(RemoverEquipamentoFavoritoEvent(equipamento: e));
                            },
                            icon: Icon(Icons.delete),
                          )

                      ),
                    ],
                  ),
                );
              },
            );
          }

          // Estado padrão / inicial
          return Center(
            child: Text(
              "Nenhum favorito encontrado.",
              style: GoogleFonts.inter(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}

