import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/data/repositories/Equipamento_repository.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


class DetalhesEquipamentoScreen extends StatefulWidget {
  final Equipamento equipamento;
  const DetalhesEquipamentoScreen({super.key, required this.equipamento});

  @override
  State<DetalhesEquipamentoScreen> createState() => _DetalhesEquipamentoScreenState();
}

class _DetalhesEquipamentoScreenState extends State<DetalhesEquipamentoScreen> {
  Equipamento? equipamento;
  final EquipamentoRepository repository = EquipamentoRepository();
  bool _isHovering = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    final eq = state.extra as Equipamento?;

    if (eq == null) return;

    equipamento = eq;

    repository.incrementarVisualizacao(widget.equipamento.id);
    setState(() {
      widget.equipamento.visualizacao += 1;
    });
  }

  Widget _buildImageCard() {
  return MouseRegion(
    onEnter: (_) => setState(() => _isHovering = true),
    onExit: (_) => setState(() => _isHovering = false),
    child: AnimatedScale(
      scale: _isHovering ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
        child: Column( 
          children: [ 
            Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              widget.equipamento.imageUrl,
              height: 400,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 120),
            ),
          ),
          SizedBox(height: 20),
        BlocBuilder<EquipamentoBloc, EquipamentoState>(
          builder: (context, state) {
            final bloc = context.read<EquipamentoBloc>();
            final isFavorito = bloc.isFavorito(widget.equipamento);

            return IconButton(
              onPressed: () {
                if (isFavorito) {
                  bloc.add(RemoverEquipamentoFavoritoEvent(equipamento: widget.equipamento));
                } else {
                  bloc.add(AdicionarEquipamentoFavoritoEvent(equipamento: widget.equipamento));
                }
              },
              icon: Icon(
                Icons.favorite,
                color: isFavorito ? Colors.red : AppColors.grey,
              ),
            );
          },
        )

        ]
      ),
    )
  );
}


Widget _buildInfoColumn() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.equipamento.nome,
        style: AppTextStyles.titleSmallx(AppColors.black),
      ),
      const SizedBox(height: 8),

      Text(
        "Marca: ${widget.equipamento.marca}",
        style: AppTextStyles.bodyLight(AppColors.black),
      ),
      const SizedBox(height: 16),

      Row(
        children: [
          Text("Código: ${widget.equipamento.code}",
              style: AppTextStyles.bodyLight(AppColors.black)),
          const SizedBox(width: 20),
          Text("Quantidade: ${widget.equipamento.quantidade}",
              style: AppTextStyles.bodyLight(AppColors.black)),
        ],
      ),
      const SizedBox(height: 16),

      Wrap(
        spacing: 8,
        children: widget.equipamento.categorias.map((c) {
          return Chip(
            label: Text(c, style: AppTextStyles.small(AppColors.white)),
            backgroundColor: AppColors.orange,
          );
        }).toList(),
      ),

      const SizedBox(height: 20),

      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text("Descrição",
                style: AppTextStyles.bodyLight(AppColors.black)),
              const SizedBox(height: 8),
              Text(widget.equipamento.descricao,
                style: GoogleFonts.inter(fontSize: 16)),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),
    ],
  );
}


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informações do Equipamento",
          style: AppTextStyles.titleSmall(AppColors.orange),
        ),
        backgroundColor: AppColors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isSmallScreen
                ? Column( // layout vertical para telas pequenas
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageCard(),
                      const SizedBox(height: 20),
                      _buildInfoColumn(),
                    ],
                  )
                : Row( // layout em duas colunas para telas grandes
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.35,
                        child: _buildImageCard(),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: constraints.maxWidth * 0.55,
                        child: _buildInfoColumn(),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  } 
}
      
    