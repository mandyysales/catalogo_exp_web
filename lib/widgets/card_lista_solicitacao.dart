import 'package:catalogo_exp_web/them/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardListaSolicitacao extends StatelessWidget {
  final String nome;
  final String funcao;
  final String email;
  final VoidCallback onPressed1; // aceitar
  final VoidCallback onPressed2; // recusar

  const CardListaSolicitacao({
    required this.nome,
    required this.funcao,
    required this.email,
    required this.onPressed1,
    required this.onPressed2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                /// Nome
                Flexible(
                  flex: 2,
                  child: Text(
                    nome,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// (função)
                Flexible(
                  flex: 1,
                  child: Text(
                    '($funcao)',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// email
                Flexible(
                  flex: 2,
                  child: Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// -------------
          /// BOTÃO ACEITAR
          /// -------------
          Container(
            width: 110,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.orange, AppColors.blue],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed1,
                borderRadius: BorderRadius.circular(30),
                child: const Center(
                  child: Text(
                    "Aceitar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),


          IconButton(
            onPressed: onPressed2,
            icon: const Icon(Icons.no_accounts_outlined),
            color: AppColors.red,
            iconSize: 26,
          ),
        ],
      ),
    );
  }
}
