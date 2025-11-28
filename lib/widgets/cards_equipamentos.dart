import 'package:catalogo_exp_web/router/Rotas.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/screens/DetalhesEquipamento_screen.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/widgets/DoubleButtonDialog.dart';
import 'package:catalogo_exp_web/widgets/custom_button_radius_peque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCardEquipamentos extends StatefulWidget {
  final Equipamento equipamento;
  final bool editar;

  const CustomCardEquipamentos({
    super.key,
    required this.equipamento,
    required this.editar,
  });

  @override
  State<CustomCardEquipamentos> createState() => _CustomCardEquipamentosState();
}

class _CustomCardEquipamentosState extends State<CustomCardEquipamentos> {
  bool _isHovered = false;



  /*void _mostrarPopupConfirmacao(String acao, VoidCallback onConfirmar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar $acao'),
        content: Text('Tem certeza que deseja $acao?'),
        actions: [
          TextButton(onPressed: () => context.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.pop(ctx);
              onConfirmar();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.orange.withOpacity(0.35),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Container(
            width: 260,
            height: 300, // ⬅ defina uma altura para o card
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min, //definir ALTURA minima 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // --- 1) IMAGEM COM ALTURA CONTROLADA ---
                Stack( children: [ 
                  ClipRRect( 
                    borderRadius: const BorderRadius.vertical( 
                      top: Radius.circular(16), 
                      ), 
                      child: Image.network(
                         widget.equipamento.imageUrl, 
                         fit: BoxFit.contain, 
                         width: double.infinity,//200, 
                         height: 100, 
                    errorBuilder: (context, error, stackTrace) { 
                      return const Icon(Icons.broken_image, 
                      size: 80, 
                      color: Colors.grey); 
                      }, 
                    ) 
                  ), 
                  Positioned( 
                    right: 8, 
                    top: 8, 
                    child: Row( children: [ 
                      CusttomButtonRadiusPequeno( 
                        text: "Ver Mais", 
                        onPressed: () { 
                          context.push(
                          AppRoutes.detalhesEquipamento, 
                          extra: widget.equipamento);//acrescentei o id 
                         },
                        backgroundColor: AppColors.orange, 
                      ), 
                      SizedBox(width: 5,), 
                      if (widget.editar == true) 
                        CusttomButtonRadiusPequeno( 
                          text: "Editar", 
                          onPressed: () { 
                            context.push(  
                            AppRoutes.addFormsEquipamento, 
                            extra: widget.equipamento, // passa o equipamento para edição 
                        ); 
                      }, 
                      backgroundColor: AppColors.blue, 
                        ), 
                      ], 
                    ), 
                  ), 
                ], 
              ),

                // --- 2) CONTEÚDO FLEXÍVEL ---
                //Expanded(
                Flexible(
                  fit: FlexFit.loose,
                  child:Container( //Padding(
                    width: 200,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.equipamento.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.equipamento.descricao,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: 14),
                        ),

                        const Spacer(),

                        // --- 3) BOTÃO DELETE ALINHADO NO FINAL ---
                        if (widget.editar == true)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: AppColors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => DoubleButtonDialog(
                                    title: "Confirmar exclusão",
                                    message: "Tem certeza que deseja excluir este equipamento?",
                                    cancelText: "Cancelar",
                                    confirmText: "Excluir",
                                    onCancel: () => Navigator.pop(context),
                                    onConfirm: () {
                                      context.read<EquipamentoBloc>().add(
                                        DeleteEquipamentoEvent(widget.equipamento.id),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
