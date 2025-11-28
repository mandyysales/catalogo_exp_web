
import 'dart:typed_data';
import 'package:catalogo_exp_web/Gemini/Descricao_requisicao.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_bloc.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_event.dart';
import 'package:catalogo_exp_web/bloc/equipamento/equipamento_state.dart';
import 'package:catalogo_exp_web/data/repositories/Equipamento_repository.dart';
import 'package:catalogo_exp_web/models/Equipamento.dart';
import 'package:catalogo_exp_web/them/colors.dart';
import 'package:catalogo_exp_web/them/text.dart';
import 'package:catalogo_exp_web/widgets/CategoriaSelectField.dart';
import 'package:catalogo_exp_web/widgets/SingleButtonDialog.dart';
import 'package:catalogo_exp_web/widgets/TextFormFieldIcon2.dart';
import 'package:catalogo_exp_web/widgets/custom_button_radius_medio.dart';
import 'package:catalogo_exp_web/widgets/custom_button_radius_peque.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_grande.dart';
import 'package:catalogo_exp_web/widgets/custom_button_retangular_medio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:image_picker/image_picker.dart';

class FormAddEquipamento extends StatefulWidget {
  final Equipamento? equipamento;

  const FormAddEquipamento({super.key, this.equipamento});

  @override
  State<FormAddEquipamento> createState() => _FormAddEquipamentoState();
}

class _FormAddEquipamentoState extends State<FormAddEquipamento> {
  final _formKey = GlobalKey<FormState>();
  final GeminiService geminiService = GeminiService();

  Uint8List? _imagemSelecionada;
  Equipamento? _equipamentoAtual;

    final List<String> categoriasDisponiveis = [
    "Mecânica",
    "Física",
    "Matemática",
    "Ótica",
    "Ocilações e Ondas",
    "Hidrostática e Hidrodinâmica",
    "Eletromagnetismo",
    "Acústica",
    "Quântica e Relatividade",
    "Equipamentos Auxiliares",
    "Outros",
  ];

  List<String> categoriasSelecionadas = [];

  final nomeController = TextEditingController();
  final marcaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final codigoController = TextEditingController();
  final descricaoController = TextEditingController();

Future<void> _selecionarImagem() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true, // necessário para Web
  );

  if (result != null && result.files.isNotEmpty) {
    setState(() {
      _imagemSelecionada = result.files.first.bytes; // Uint8List
    });
  }
}



@override
void didChangeDependencies() {
  super.didChangeDependencies();

    if (_equipamentoAtual == null) {
      _equipamentoAtual = widget.equipamento; //?? 
          //ModalRoute.of(context)?.settings.arguments as Equipamento?;

    
    if (_equipamentoAtual == null) {
      quantidadeController.text = "1";        // valor padrão  
      marcaController.text = 'desconhecida';
      descricaoController.text = 'Sem Descrição';
    }
    
    if (_equipamentoAtual != null) {
      nomeController.text = _equipamentoAtual!.nome;
      marcaController.text = _equipamentoAtual!.marca;
      quantidadeController.text = _equipamentoAtual!.quantidade.toString();
      categoriasSelecionadas = List.from(_equipamentoAtual!.categorias);
      codigoController.text = _equipamentoAtual!.code;
      descricaoController.text = _equipamentoAtual!.descricao;
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return BlocListener<EquipamentoBloc, EquipamentoState>(
      listener: (context, state) {
        if (state is EquipamentoSuccess) {
          showDialog(
            context: context,
            builder: (_) => SingleButtonDialog(
              title: "Sucesso!",
              message: "Equipamento adicionado com sucesso.",
              buttonText: "OK",
              onPressed: () {
                Navigator.pop(context); // fecha diálogo
                context.pop();          // volta tela
              },
            ),
          );
        }

        // ---------- SUCESSO AO ATUALIZAR ----------
        if (state is EquipamentoUpdated) {
          showDialog(
            context: context,
            builder: (_) => SingleButtonDialog(
              title: "Atualizado!",
              message: "Equipamento atualizado com sucesso.",
              buttonText: "OK",
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
            ),
          );
        }

        // ---------- ERRO ----------
        if (state is EquipamentoError) {
          showDialog(
            context: context,
            builder: (_) => SingleButtonDialog(
              title: "Erro",
              message: state.message,
              buttonText: "Fechar",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Adicionar equipamento ao catálogo",
              style: AppTextStyles.titleSmall(AppColors.orange)
            ),
          ),
          centerTitle: false,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ----------- FORMULÁRIO -----------
              Expanded(
                flex: 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormFieldCustom(
                        label: "Nome",
                        icon: Icons.text_fields,
                        controller: nomeController,
                        width: 755,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                              return "O nome é obrigatório.";
                            }
                            return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormFieldCustom(
                            label: "Marca",
                            icon: Icons.precision_manufacturing,
                            width: 475,
                            controller: marcaController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "O nome é obrigatório.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(width: 15),
                          FormFieldCustom(
                            label: "Quantidade",
                            width: 265,
                            icon: Icons.calendar_today,
                            controller: quantidadeController,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 475,
                            child: CategoriaSelectField(
                              initialValue: categoriasSelecionadas,
                              categoriasDisponiveis: categoriasDisponiveis,
                              onChanged: (value) {
                                setState(() {
                                  categoriasSelecionadas = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Selecione ao menos uma categoria.";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          FormFieldCustom(
                            label: "Código",
                            width: 265,
                            icon: Icons.qr_code,
                            controller: codigoController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Digite n/a para valor desconhecido";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      FormFieldCustom(
                        label: "Descrição",
                        icon: Icons.description,
                        controller: descricaoController,
                        height: 220,
                        width: 755,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "O nome é obrigatório.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 50),

              // ----------- IMAGEM + BOTÃO ----------- 
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selecionarImagem,
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.orange, width: 2),
                          image: _imagemSelecionada != null
                            ? DecorationImage(
                                image: MemoryImage(_imagemSelecionada!),
                                fit: BoxFit.cover,
                              )
                            : (_equipamentoAtual != null && _equipamentoAtual!.imageUrl.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(_equipamentoAtual!.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,

                        ),
                        child: _imagemSelecionada == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo,
                                        color: AppColors.orange, size: 40),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Adicionar imagem",
                                      style: GoogleFonts.inter(
                                        color: AppColors.orange,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      children: [
                        CusttomButtonRadiusMedio(
                          onPressed: () async {
                            final nome = nomeController.text;
                            if (nome.isEmpty) return;
                            final equipamentoRepository = EquipamentoRepository();
                            // Chama o serviço Gemini
                            final descricao = await equipamentoRepository.gerarDescricaoEquipamento(nomeController.text);

                            // Preenche o campo de descrição
                            descricaoController.text = descricao;
                          },
                            text: "Gerar Descrição",
                            backgroundColor: AppColors.blue,
                        ),

                        SizedBox(width: 10,),

                        CusttomButtonRadiusPequeno(
                          text: "Salvar",
                          backgroundColor: AppColors.orange,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Cria o equipamento baseado nos campos do formulário
                              final equip = Equipamento(
                                id: _equipamentoAtual?.id ?? '', // se for editar, mantém o id
                                nome: nomeController.text,
                                code: codigoController.text,
                                quantidade: int.parse(quantidadeController.text),
                                marca: marcaController.text,
                                descricao: descricaoController.text,
                                categorias: categoriasSelecionadas,
                                imageUrl: _equipamentoAtual?.imageUrl ?? '', // mantém a URL se editar
                              );

                              if (_equipamentoAtual == null) {
                                // ADD
                                context.read<EquipamentoBloc>().add(
                                  AddEquipamentoEvent(
                                    equipamento: equip,
                                    imagemWb: _imagemSelecionada,
                                  ),
                                );
                              } else {
                                // UPDATE
                                context.read<EquipamentoBloc>().add(
                                  UpdateEquipamentoEvent(
                                    equipamento: equip,
                                    imagemWb: _imagemSelecionada,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
